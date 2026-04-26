import { prisma } from '../../lib/prisma.js';

export class BannersService {
  async listActive() {
    return prisma.banner.findMany({
      where: { isActive: true },
      orderBy: { order: 'asc' },
    });
  }

  async list() {
    return prisma.banner.findMany({ orderBy: { order: 'asc' } });
  }

  async create(data: {
    title: string;
    subtitle?: string;
    imageUrl: string;
    linkType?: 'NONE' | 'COMPANY' | 'PROMOTION';
    linkId?: string;
    order?: number;
  }) {
    return prisma.banner.create({ data });
  }

  async update(id: string, data: Partial<{
    title: string;
    subtitle: string;
    imageUrl: string;
    linkType: 'NONE' | 'COMPANY' | 'PROMOTION';
    linkId: string;
    isActive: boolean;
    order: number;
  }>) {
    return prisma.banner.update({ where: { id }, data });
  }

  async delete(id: string) {
    return prisma.banner.delete({ where: { id } });
  }
}
