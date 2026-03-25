import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Contact } from './entities/contact.entity';

@Injectable()
export class ContactsService {
  constructor(
    @InjectRepository(Contact)
    private contactsRepository: Repository<Contact>,
  ) {}

  async findAllByUser(userId: string): Promise<Contact[]> {
    return this.contactsRepository.find({ where: { user: { id: userId } } });
  }

  async create(createContactDto: any, userId: string): Promise<Contact> {
    const contact = this.contactsRepository.create({
      ...createContactDto,
      user: { id: userId } as any,
    } as any) as unknown as Contact;
    return this.contactsRepository.save(contact);
  }

  async update(id: string, updateContactDto: any): Promise<Contact> {
    await this.contactsRepository.update(id, updateContactDto);
    const contact = await this.contactsRepository.findOne({ where: { id } });
    if (!contact) throw new NotFoundException('Contacto no encontrado');
    return contact;
  }

  async remove(id: string): Promise<void> {
    await this.contactsRepository.delete(id);
  }
}
