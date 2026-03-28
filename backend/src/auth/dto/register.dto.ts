import { IsString, MinLength, IsOptional, IsEnum, Matches } from 'class-validator';
import { UserRole } from '../../users/entities/user.entity';
import { IsEcuadorianId } from '../../common/validators/ecuadorian-id.validator';

export class RegisterDto {
  @IsString({ message: 'El nombre debe ser una cadena de texto' })
  nombre: string;

  @IsString({ message: 'El usuario o correo es obligatorio' })
  email: string;

  @IsString()
  @MinLength(6, { message: 'Mínimo 6 caracteres' })
  @Matches(/(?=.*[A-Z])/, { message: 'Debe incluir al menos una MAYÚSCULA' })
  @Matches(/(?=.*[a-z])/, { message: 'Debe incluir al menos una minúscula' })
  @Matches(/(?=.*\d)/, { message: 'Debe incluir al menos un número' })
  password: string;

  @IsOptional()
  @IsString()
  @IsEcuadorianId({ message: 'Cédula o RUC ecuatoriano inválido' })
  cedula?: string;

  @IsOptional()
  @IsString()
  telefono?: string;

  @IsOptional()
  @IsEnum(UserRole)
  rol?: UserRole;
}
