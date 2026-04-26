import { Request, Response, NextFunction } from 'express';
import { env } from '../config/env.js';

export function adminAuth(req: Request, res: Response, next: NextFunction) {
  const key = req.headers['x-admin-key'];
  if (!key || key !== env.ADMIN_KEY) {
    return res.status(403).json({ erro: 'Acesso negado' });
  }
  next();
}
