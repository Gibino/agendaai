import { Request, Response } from 'express';
import { BannersService } from './banners.service.js';

const bannersService = new BannersService();

// Público — retorna somente banners ativos, ordenados
export const listActiveBanners = async (_req: Request, res: Response) => {
  try {
    const banners = await bannersService.listActive();
    res.status(200).json({ dados: banners });
  } catch (error: any) {
    res.status(500).json({ erro: error.message });
  }
};

// Admin — lista todos (incluindo inativos)
export const listAllBanners = async (_req: Request, res: Response) => {
  try {
    const banners = await bannersService.list();
    res.status(200).json({ dados: banners });
  } catch (error: any) {
    res.status(500).json({ erro: error.message });
  }
};

export const createBanner = async (req: Request, res: Response) => {
  try {
    const { title, subtitle, imageUrl, linkType, linkId, order } = req.body;
    if (!title || !imageUrl) {
      return res.status(400).json({ erro: 'Título e imageUrl são obrigatórios' });
    }
    const banner = await bannersService.create({ title, subtitle, imageUrl, linkType, linkId, order });
    res.status(201).json({ dados: banner });
  } catch (error: any) {
    res.status(500).json({ erro: error.message });
  }
};

export const updateBanner = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const banner = await bannersService.update(id, req.body);
    res.status(200).json({ dados: banner });
  } catch (error: any) {
    res.status(500).json({ erro: error.message });
  }
};

export const deleteBanner = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    await bannersService.delete(id);
    res.status(204).send();
  } catch (error: any) {
    res.status(500).json({ erro: error.message });
  }
};
