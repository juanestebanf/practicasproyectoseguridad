import { Controller, Get, Post, Body, Patch, Param, Delete, UseGuards, Request, UseInterceptors, UploadedFile } from '@nestjs/common';
import { AlertsService } from './alerts.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { FileInterceptor } from '@nestjs/platform-express';
import { diskStorage } from 'multer';
import { extname } from 'path';
import { ApiTags, ApiBearerAuth, ApiOperation } from '@nestjs/swagger';
import { UserRole } from '../users/entities/user.entity';
import { Roles } from '../auth/decorators/roles.decorator';
import { RolesGuard } from '../auth/guards/roles.guard';

@ApiTags('alerts')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('alerts')
export class AlertsController {
  constructor(private readonly alertsService: AlertsService) {}

  @ApiOperation({ summary: 'Crear una nueva alerta' })
  @Post()
  async create(@Body() createAlertDto: any, @Request() req) {
    return this.alertsService.create(createAlertDto, req.user);
  }

  @ApiOperation({ summary: 'Listar alertas activas (Dashboard Admin)' })
  @Get('active')
  async findAllActive() {
    return this.alertsService.findAllActive();
  }

  @ApiOperation({ summary: 'Listar alertas finalizadas' })
  @Get('finalized')
  async findFinalized() {
    return this.alertsService.findFinalized();
  }

  @ApiOperation({ summary: 'Listar historial de alertas del usuario logueado' })
  @Get('history')
  async findHistory(@Request() req) {
    return this.alertsService.findByUser(req.user.userId);
  }

  @ApiOperation({ summary: 'Listar alertas asignadas al operador logueado' })
  @Get('assigned')
  async findAssigned(@Request() req) {
    return this.alertsService.findByOperator(req.user.userId);
  }

  @ApiOperation({ summary: 'Obtener alerta por ID' })
  @Get(':id')
  async findOne(@Param('id') id: string) {
    return this.alertsService.findOne(id);
  }

  @ApiOperation({ summary: 'Aceptar alerta (Operador)' })
  @Patch(':id/accept')
  async acceptAlert(@Param('id') id: string, @Request() req) {
    return this.alertsService.acceptAlert(id, req.user.userId);
  }

  @ApiOperation({ summary: 'Asignar autoridad a una alerta' })
  @Patch(':id/assign-authority')
  async assignAuthority(@Param('id') id: string, @Body('authorityId') authorityId: string) {
    return this.alertsService.assignAuthority(id, authorityId);
  }

  @ApiOperation({ summary: 'Subir evidencia fotográfica o en video' })
  @Post(':id/upload-evidence')
  @UseInterceptors(FileInterceptor('file', {
    storage: diskStorage({
      destination: './uploads/evidences',
      filename: (req, file, cb) => {
        const randomName = Array(32).fill(null).map(() => (Math.round(Math.random() * 16)).toString(16)).join('');
        return cb(null, `${randomName}${extname(file.originalname)}`);
      }
    })
  }))
  async uploadEvidence(@Param('id') id: string, @UploadedFile() file: Express.Multer.File) {
    return this.alertsService.uploadEvidence(id, file.path, file.mimetype);
  }

  @ApiOperation({ summary: 'Asignar operador a una alerta (Admin)' })
  @Patch(':id/assign-operator')
  async assignOperator(@Param('id') id: string, @Body('operatorId') operatorId: string) {
    return this.alertsService.assignOperator(id, operatorId);
  }

  @ApiOperation({ summary: 'Subir reporte final de la alerta (Operador)' })
  @Post(':id/upload-report')
  @UseInterceptors(FileInterceptor('file', {
    storage: diskStorage({
      destination: './uploads/reports',
      filename: (req, file, cb) => {
        const randomName = Array(32).fill(null).map(() => (Math.round(Math.random() * 16)).toString(16)).join('');
        return cb(null, `${randomName}${extname(file.originalname)}`);
      }
    })
  }))
  async uploadReport(@Param('id') id: string, @UploadedFile() file: Express.Multer.File) {
    return this.alertsService.uploadReport(id, file.path);
  }

  @ApiOperation({ summary: 'Finalizar alerta con reporte de texto (Operador)' })
  @Patch(':id/finalize')
  async finalize(@Param('id') id: string, @Body('report') report: string) {
    return this.alertsService.finalizeWithReport(id, report);
  }

  @ApiOperation({ summary: 'Listar reportes pendientes de aprobación (Admin)' })
  @Get('pending-approval')
  async findPendingApproval() {
    return this.alertsService.findPendingApproval();
  }

  @ApiOperation({ summary: 'Aprobar reporte final (Admin)' })
  @Patch(':id/approve')
  async approve(@Param('id') id: string) {
    return this.alertsService.approveReport(id);
  }

  @ApiOperation({ summary: 'Rechazar reporte final con feedback (Admin)' })
  @Patch(':id/reject')
  async reject(@Param('id') id: string, @Body('feedback') feedback: string) {
    return this.alertsService.rejectReport(id, feedback);
  }

  @ApiOperation({ summary: 'Resumen de estadísticas (Admin)' })
  @Get('summary')
  async getSummary() {
    return this.alertsService.getSummary();
  }

  @ApiOperation({ summary: 'Estadísticas del operador logueado' })
  @Get('my-stats')
  async getMyStats(@Request() req) {
    return this.alertsService.getOperatorStats(req.user.userId);
  }

  @ApiOperation({ summary: 'Eliminar alerta (Admin/Superadmin)' })
  @Roles(UserRole.ADMIN)
  @Delete(':id')
  async deleteAlert(@Param('id') id: string) {
    return this.alertsService.delete(id);
  }
}
