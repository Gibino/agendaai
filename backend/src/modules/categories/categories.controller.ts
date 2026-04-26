import { Request, Response } from 'express';
import { CategoriesService } from './categories.service.js';

const categoriesService = new CategoriesService();

export const listCategories = async (req: Request, res: Response) => {
  try {
    const categories = await categoriesService.listAll();
    res.status(200).json({ dados: categories });
  } catch (error: any) {
    res.status(500).json({ erro: error.message });
  }
};

export const createCategory = async (req: Request, res: Response) => {
  try {
    const { name, description, icon } = req.body;
    if (!name) {
      return res.status(400).json({ erro: 'Nome é obrigatório' });
    }
    const category = await categoriesService.create(name, description, icon);
    res.status(201).json({ dados: category });
  } catch (error: any) {
    res.status(500).json({ erro: error.message });
  }
};

export const deleteCategory = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    await categoriesService.delete(id);
    res.status(204).send();
  } catch (error: any) {
    res.status(500).json({ erro: error.message });
  }
};
