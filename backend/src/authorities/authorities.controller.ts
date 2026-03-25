import { Controller, Get, UseGuards } from '@nestjs/common';
import { AuthoritiesService } from './authorities.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { ApiTags, ApiBearerAuth, ApiOperation } from '@nestjs/swagger';

@ApiTags('authorities')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('authorities')
export class AuthoritiesController {
  constructor(private readonly authoritiesService: AuthoritiesService) {}

  @ApiOperation({ summary: 'Listar agencias de autoridad disponibles' })
  @Get()
  async findAll() {
    return this.authoritiesService.findAll();
  }
}
