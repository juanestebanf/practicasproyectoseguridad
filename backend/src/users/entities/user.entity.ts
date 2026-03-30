import { Entity, PrimaryGeneratedColumn, Column, OneToMany, CreateDateColumn, UpdateDateColumn } from 'typeorm';
import { Alert } from '../../alerts/entities/alert.entity';
import { Contact } from '../../contacts/entities/contact.entity';

export enum UserRole {
  SUPERADMIN = 'superadmin',
  ADMIN = 'admin',
  OPERADOR = 'operador',
  USER = 'user',
}

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ unique: true })
  email: string;

  @Column({ select: false })
  password: string;

  @Column()
  nombre: string;

  @Column({ unique: true, nullable: true })
  cedula: string;

  @Column({ nullable: true })
  telefono: string;

  @Column({ nullable: true })
  ciudad: string;

  @Column({
    type: 'enum',
    enum: UserRole,
    default: UserRole.USER,
  })
  rol: UserRole;

  @Column({ default: true })
  active: boolean;

  @Column({ type: 'float', nullable: true })
  lat: number;

  @Column({ type: 'float', nullable: true })
  lng: number;

  @Column({ nullable: true })
  foto: string;

  @Column({ name: 'tipo_sangre', nullable: true })
  tipoSangre: string;

  @Column({ type: 'text', nullable: true })
  alergias: string;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;

  @Column({ name: 'reset_token', nullable: true, select: false })
  resetToken: string;

  @Column({ name: 'reset_token_expires', type: 'timestamp', nullable: true, select: false })
  resetTokenExpires: Date;

  @OneToMany(() => Alert, (alert) => alert.ciudadano)
  alerts: Alert[];

  @OneToMany(() => Contact, (contact) => contact.user)
  contacts: Contact[];
}
