import { prisma } from '../../lib/prisma.js';

export class PromotionsService {
  async listActive() {
    const now = new Date();
    return prisma.promotion.findMany({
      where: {
        isActive: true,
        startsAt: { lte: now },
        endsAt: { gte: now },
      },
      include: { company: { select: { id: true, name: true } } },
      orderBy: { startsAt: 'desc' },
    });
  }

  async list() {
    return prisma.promotion.findMany({
      include: { company: { select: { id: true, name: true } } },
      orderBy: { createdAt: 'desc' },
    });
  }

  async create(data: {
    title: string;
    description?: string;
    imageUrl?: string;
    companyId?: string;
    startsAt: Date;
    endsAt: Date;
  }) {
    return prisma.promotion.create({ data });
  }

  async update(id: string, data: Partial<{
    title: string;
    description: string;
    imageUrl: string;
    companyId: string;
    startsAt: Date;
    endsAt: Date;
    isActive: boolean;
  }>) {
    return prisma.promotion.update({ where: { id }, data });
  }

  async delete(id: string) {
    return prisma.promotion.delete({ where: { id } });
  }
}
