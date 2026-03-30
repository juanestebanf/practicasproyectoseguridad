import { IsString, MinLength, Matches } from 'class-validator';

export class LoginDto {
  @IsString({ message: 'El usuario o correo es obligatorio' })
  email: string;

  @IsString()
  @MinLength(6, { message: 'La contraseña debe tener al menos 6 caracteres' })
  password: string;
}

