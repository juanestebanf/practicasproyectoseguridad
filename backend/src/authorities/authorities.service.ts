import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Authority } from './entities/authority.entity';

@Injectable()
export class AuthoritiesService {
  constructor(
    @InjectRepository(Authority)
    private authoritiesRepository: Repository<Authority>,
  ) {}

  async findAll(): Promise<Authority[]> {
    return this.authoritiesRepository.find();
  }

  async seed() {
    const count = await this.authoritiesRepository.count();
    if (count === 0) {
      const initial = [
        { nombre: 'Policía Nacional', tipo: 'POLICIA' },
        { nombre: 'Bomberos Loja', tipo: 'BOMBEROS' },
        { nombre: 'Ambulancia 911', tipo: 'AMBULANCIA' },
        { nombre: 'Seguridad Ciudadana', tipo: 'SEGURIDAD' },
      ];
      await this.authoritiesRepository.save(initial);
    }
  }
}
