import { Router } from 'express';
import { listCompanies, getCompany, createCompany, deleteCompany } from './companies.controller.js';
import { adminAuth } from '../../middlewares/adminAuth.js';

const router = Router();

// Public
router.get('/', listCompanies);
router.get('/:id', getCompany);

// Admin only
router.post('/', adminAuth, createCompany);
router.delete('/:id', adminAuth, deleteCompany);

export default router;
