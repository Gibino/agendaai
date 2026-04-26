import { Router } from 'express';
import {
  listActiveBanners,
  listAllBanners,
  createBanner,
  updateBanner,
  deleteBanner,
} from './banners.controller.js';
import { adminAuth } from '../../middlewares/adminAuth.js';

const router = Router();

// Público
router.get('/', listActiveBanners);

// Admin only
router.get('/todos', adminAuth, listAllBanners);
router.post('/', adminAuth, createBanner);
router.patch('/:id', adminAuth, updateBanner);
router.delete('/:id', adminAuth, deleteBanner);

export default router;
