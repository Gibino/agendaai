import { prisma } from '../../lib/prisma.js';

export class CompaniesService {
  async list(filters: { search?: string; categoryId?: string }, skip = 0, take = 20) {
    const where: any = {};

    if (filters.search) {
      where.OR = [
        { name: { contains: filters.search, mode: 'insensitive' } },
        { description: { contains: filters.search, mode: 'insensitive' } },
      ];
    }

    if (filters.categoryId) {
      where.categoryId = filters.categoryId;
    }

    const [total, companies] = await Promise.all([
      prisma.company.count({ where }),
      prisma.company.findMany({
        where,
        skip,
        take,
        include: { category: true },
        orderBy: { name: 'asc' },
      }),
    ]);

    return { total, skip, take, companies };
  }

  async getById(id: string) {
    return prisma.company.findUnique({
      where: { id },
      include: { category: true },
    });
  }

  getWhatsAppLink(phone: string) {
    const cleanPhone = phone.replace(/\D/g, '');
    const fullNumber = cleanPhone.startsWith('55') ? cleanPhone : `55${cleanPhone}`;
    const message = encodeURIComponent('Olá! Encontrei você no Agenda AI.');
    return `https://wa.me/${fullNumber}?text=${message}`;
  }

  // Admin only
  async create(data: { name: string; description?: string; phone: string; address?: string; categoryId: string }) {
    return prisma.company.create({ data });
  }

  // Admin only
  async delete(id: string) {
    return prisma.company.delete({ where: { id } });
  }
}
