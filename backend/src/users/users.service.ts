import { Injectable, NotFoundException, OnModuleInit } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User, UserRole } from './entities/user.entity';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UsersService implements OnModuleInit {
  constructor(
    @InjectRepository(User)
    private usersRepository: Repository<User>,
  ) {}

  async onModuleInit() {
    await this.seedSuperAdmin();
  }

  private async seedSuperAdmin() {
    const email = 'master@gmail.com';
    const exists = await this.usersRepository.findOne({ where: { email } });
    
    const hashedPassword = await bcrypt.hash('Security2620', 10);

    if (!exists) {
      console.log('🌱 Seeding Superadmin...');
      const superAdmin = this.usersRepository.create({
        email: email,
        password: hashedPassword,
        nombre: 'Super Supervisor',
        rol: UserRole.SUPERADMIN,
        cedula: '0000000000',
        active: true,
      });
      await this.usersRepository.save(superAdmin);
      console.log('✅ Superadmin created successfully.');
    } else {
      // Si ya existe, nos aseguramos que tenga el rol y contraseña correctos
      await this.usersRepository.update(exists.id, {
        password: hashedPassword,
        rol: UserRole.SUPERADMIN
      });
      console.log('🔄 Superadmin credentials updated.');
    }
  }


  async create(userData: any): Promise<User> {
    const password = userData.password || '123456';
    const hashedPassword = await bcrypt.hash(password, 10);
    const user = this.usersRepository.create({
      ...userData,
      password: hashedPassword,
    } as any) as unknown as User;
    return this.usersRepository.save(user);
  }

  async findByEmail(identifier: string): Promise<User | null> {
    return this.usersRepository.findOne({
      where: [
        { email: identifier },
        { cedula: identifier }
      ],
      select: ['id', 'email', 'password', 'nombre', 'rol', 'active', 'foto'],
    });
  }

  async findByCedula(cedula: string): Promise<User | null> {
    return this.usersRepository.findOne({
      where: { cedula: cedula },
      select: ['id', 'email', 'password', 'nombre', 'rol', 'cedula', 'active', 'foto'],
    });
  }

  async findAll(rol?: string): Promise<User[]> {
    const whereCondition = rol ? { rol: rol as any } : {};
    return this.usersRepository.find({
      where: whereCondition,
      select: ['id', 'nombre', 'email', 'rol', 'telefono', 'active', 'foto'],
    });
  }

  async findOne(id: string): Promise<User> {
    const user = await this.usersRepository.findOne({ where: { id } });
    if (!user) throw new NotFoundException('Usuario no encontrado');
    return user;
  }

  async update(id: string, userData: Partial<User>): Promise<User> {
    if (userData.password) {
      userData.password = await bcrypt.hash(userData.password, 10);
    }
    await this.usersRepository.update(id, userData);
    return this.findOne(id);
  }

  async updatePlain(id: string, userData: any): Promise<User> {
    await this.usersRepository.update(id, userData);
    return this.findOne(id);
  }

  async updateRelative(id: string, userData: any): Promise<User> {
    await this.usersRepository.update(id, userData);
    return this.findOne(id);
  }

  async findByResetToken(token: string): Promise<User | null> {
    return this.usersRepository.findOne({
      where: { resetToken: token },
      select: ['id', 'email', 'resetTokenExpires', 'password'],
    });
  }

  async delete(id: string): Promise<void> {
    const user = await this.findOne(id);
    await this.usersRepository.remove(user);
  }
}
