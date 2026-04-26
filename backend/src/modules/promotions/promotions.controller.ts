import { Request, Response } from 'express';
import { PromotionsService } from './promotions.service.js';

const promotionsService = new PromotionsService();

// Público — retorna somente promoções ativas no período atual
export const listActivePromotions = async (_req: Request, res: Response) => {
  try {
    const promotions = await promotionsService.listActive();
    res.status(200).json({ dados: promotions });
  } catch (error: any) {
    res.status(500).json({ erro: error.message });
  }
};

// Admin — lista todas
export const listAllPromotions = async (_req: Request, res: Response) => {
  try {
    const promotions = await promotionsService.list();
    res.status(200).json({ dados: promotions });
  } catch (error: any) {
    res.status(500).json({ erro: error.message });
  }
};

export const createPromotion = async (req: Request, res: Response) => {
  try {
    const { title, description, imageUrl, companyId, startsAt, endsAt } = req.body;
    if (!title || !startsAt || !endsAt) {
      return res.status(400).json({ erro: 'Título, startsAt e endsAt são obrigatórios' });
    }
    const promotion = await promotionsService.create({
      title,
      description,
      imageUrl,
      companyId,
      startsAt: new Date(startsAt),
      endsAt: new Date(endsAt),
    });
    res.status(201).json({ dados: promotion });
  } catch (error: any) {
    res.status(500).json({ erro: error.message });
  }
};

export const updatePromotion = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const data = { ...req.body };
    if (data.startsAt) data.startsAt = new Date(data.startsAt);
    if (data.endsAt) data.endsAt = new Date(data.endsAt);
    const promotion = await promotionsService.update(id, data);
    res.status(200).json({ dados: promotion });
  } catch (error: any) {
    res.status(500).json({ erro: error.message });
  }
};

export const deletePromotion = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    await promotionsService.delete(id);
    res.status(204).send();
  } catch (error: any) {
    res.status(500).json({ erro: error.message });
  }
};
