import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, CreateDateColumn, OneToMany, JoinColumn } from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { Authority } from '../../authorities/entities/authority.entity';

export enum AlertStatus {
  PENDIENTE = 'pendiente',
  EN_PROGRESO = 'en_progreso',
  AUTORIDAD_ASIGNADA = 'autoridad_asignada',
  ESPERANDO_APROBACION = 'esperando_aprobacion',
  FINALIZADA = 'finalizada',
  RECHAZADA = 'rechazada',
}

@Entity('alerts')
export class Alert {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  titulo: string;

  @Column('text')
  descripcion: string;

  @Column()
  prioridad: string; 

  @Column({
    type: 'enum',
    enum: AlertStatus,
    default: AlertStatus.PENDIENTE,
  })
  estado: AlertStatus;

  @Column()
  ubicacion: string;

  @Column('float')
  lat: number;

  @Column('float')
  lng: number;

  @CreateDateColumn()
  fecha: Date;

  @Column({ name: 'ciudadano_id' })
  ciudadano_id: string;

  @ManyToOne(() => User, (user) => user.alerts)
  @JoinColumn({ name: 'ciudadano_id' })
  ciudadano: User;

  @Column({ name: 'operador_id', nullable: true })
  operador_id: string;

  @ManyToOne(() => User, (user) => user.alerts, { nullable: true })
  @JoinColumn({ name: 'operador_id' })
  operador: User;

  @Column({ name: 'autoridad_id', nullable: true })
  autoridad_id: string;

  @ManyToOne(() => Authority, { nullable: true })
  @JoinColumn({ name: 'autoridad_id' })
  autoridad: Authority;

  @Column({ nullable: true })
  reporte_file_path: string;

  @Column({ type: 'text', nullable: true })
  reporte_texto: string;

  @Column({ type: 'text', nullable: true })
  admin_feedback: string;

  @OneToMany(() => Evidence, (evidence) => evidence.alert)
  evidencias: Evidence[];

  @OneToMany(() => AlertEvent, (event) => event.alert)
  historial: AlertEvent[];
}

@Entity('evidence')
export class Evidence {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  file_path: string;

  @Column()
  file_type: string;

  @ManyToOne(() => Alert, (alert) => alert.evidencias)
  @JoinColumn({ name: 'alert_id' })
  alert: Alert;
}

@Entity('alert_events')
export class AlertEvent {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  tipo: string; // creada, asignada, cambio_estado, reporte_subido, etc.

  @CreateDateColumn()
  fecha: Date;

  @Column('text')
  descripcion: string;

  @ManyToOne(() => Alert, (alert) => alert.historial)
  @JoinColumn({ name: 'alert_id' })
  alert: Alert;
}
