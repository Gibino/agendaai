import { prisma } from '../../lib/prisma.js';

export class CategoriesService {
  async listAll() {
    return prisma.category.findMany({
      orderBy: { name: 'asc' },
    });
  }

  // Admin only
  async create(name: string, icon?: string) {
    const slug = name
      .toLowerCase()
      .normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '')
      .replace(/[^a-z0-9]+/g, '-')
      .replace(/(^-|-$)+/g, '');
    return prisma.category.create({
      data: { name, slug, icon },
    });
  }

  // Admin only
  async delete(id: string) {
    return prisma.category.delete({
      where: { id },
    });
  }
}
