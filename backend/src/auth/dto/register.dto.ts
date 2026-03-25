import { IsString, MinLength, IsOptional, IsEnum, Matches, Length } from 'class-validator';
import { UserRole } from '../../users/entities/user.entity';

export class RegisterDto {
  @IsString({ message: 'El nombre debe ser una cadena de texto' })
  nombre: string;

  @IsString({ message: 'El usuario o correo es obligatorio' })
  email: string;

  @IsString()
  @MinLength(6, { message: 'La contraseña debe tener al menos 6 caracteres' })
  @Matches(/(?=.*[A-Z])/, { message: 'La contraseña debe contener al menos una mayúscula' })
  @Matches(/(?=.*\d)/, { message: 'La contraseña debe contener al menos un número' })
  password: string;

  @IsOptional()
  @IsString()
  @Length(11, 11, { message: 'La cédula debe tener exactamente 11 dígitos' })
  cedula?: string;

  @IsOptional()
  @IsString()
  telefono?: string;

  @IsOptional()
  @IsEnum(UserRole)
  rol?: UserRole;
}
