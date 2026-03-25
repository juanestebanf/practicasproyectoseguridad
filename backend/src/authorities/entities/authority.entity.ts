import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity('authorities')
export class Authority {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  nombre: string;

  @Column()
  tipo: string; // POLICIA, BOMBEROS, AMBULANCIA, etc.
}
