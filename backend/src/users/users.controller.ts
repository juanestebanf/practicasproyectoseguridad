import { Controller, Get, Patch, Delete, Body, UseGuards, Request, Query, Param } from '@nestjs/common';
import { UsersService } from './users.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { UserRole } from './entities/user.entity';
import { ApiTags, ApiBearerAuth, ApiOperation } from '@nestjs/swagger';

@ApiTags('users')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @ApiOperation({ summary: 'Obtener usuarios por rol' })
  @Roles(UserRole.ADMIN)
  @Get()
  async findAll(@Query('rol') rol: string) {
    return this.usersService.findAll(rol);
  }

  @ApiOperation({ summary: 'Obtener mi perfil' })
  @Get('profile')
  async getProfile(@Request() req) {
    return this.usersService.findOne(req.user.userId);
  }

  @ApiOperation({ summary: 'Actualizar mi perfil' })
  @Patch('profile')
  async updateProfile(@Request() req, @Body() updateUserDto: any) {
    return this.usersService.update(req.user.userId, updateUserDto);
  }

  @ApiOperation({ summary: 'Actualizar cualquier usuario (Admin)' })
  @Roles(UserRole.ADMIN)
  @Patch(':id')
  async updateUser(@Param('id') id: string, @Body() updateUserDto: any) {
    return this.usersService.update(id, updateUserDto);
  }

  @ApiOperation({ summary: 'Eliminar cualquier usuario (Admin)' })
  @Roles(UserRole.ADMIN)
  @Delete(':id')
  async deleteUser(@Param('id') id: string) {
    return this.usersService.delete(id);
  }
}
