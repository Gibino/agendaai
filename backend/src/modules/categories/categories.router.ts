import { Router } from 'express';
import { listCategories, createCategory, deleteCategory } from './categories.controller.js';
import { adminAuth } from '../../middlewares/adminAuth.js';

const router = Router();

// Public
router.get('/', listCategories);

// Admin only
router.post('/', adminAuth, createCategory);
router.delete('/:id', adminAuth, deleteCategory);

export default router;
