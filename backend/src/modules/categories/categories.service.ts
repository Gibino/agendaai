import { prisma } from '../../lib/prisma.js';

export class CategoriesService {
  async listAll() {
    return prisma.category.findMany({
      orderBy: { name: 'asc' },
    });
  }

  // Admin only
  async create(name: string, description?: string, icon?: string) {
    return prisma.category.create({
      data: { name, description, icon },
    });
  }

  // Admin only
  async delete(id: string) {
    return prisma.category.delete({
      where: { id },
    });
  }
}
