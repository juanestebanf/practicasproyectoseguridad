import { Controller, Get, Post, Body, Put, Param, Delete, UseGuards, Request } from '@nestjs/common';
import { ContactsService } from './contacts.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { ApiTags, ApiBearerAuth, ApiOperation } from '@nestjs/swagger';

@ApiTags('contacts')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('contacts')
export class ContactsController {
  constructor(private readonly contactsService: ContactsService) {}

  @ApiOperation({ summary: 'Listar mis contactos SOS' })
  @Get()
  async findAll(@Request() req) {
    return this.contactsService.findAllByUser(req.user.userId);
  }

  @ApiOperation({ summary: 'Agregar un contacto SOS' })
  @Post()
  async create(@Body() createContactDto: any, @Request() req) {
    return this.contactsService.create(createContactDto, req.user.userId);
  }

  @ApiOperation({ summary: 'Actualizar contacto SOS' })
  @Put(':id')
  async update(@Param('id') id: string, @Body() updateContactDto: any) {
    return this.contactsService.update(id, updateContactDto);
  }

  @ApiOperation({ summary: 'Eliminar contacto SOS' })
  @Delete(':id')
  async remove(@Param('id') id: string) {
    return this.contactsService.remove(id);
  }
}
