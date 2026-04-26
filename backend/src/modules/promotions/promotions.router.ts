import { Router } from 'express';
import {
  listActivePromotions,
  listAllPromotions,
  createPromotion,
  updatePromotion,
  deletePromotion,
} from './promotions.controller.js';
import { adminAuth } from '../../middlewares/adminAuth.js';

const router = Router();

// Público — somente promoções ativas no período atual
router.get('/', listActivePromotions);

// Admin only
router.get('/todas', adminAuth, listAllPromotions);
router.post('/', adminAuth, createPromotion);
router.patch('/:id', adminAuth, updatePromotion);
router.delete('/:id', adminAuth, deletePromotion);

export default router;
