import { Request, Response, NextFunction } from 'express';
import { verifyAccessToken } from '../lib/jwt.js';

export interface AuthRequest extends Request {
  user?: {
    id: string;
  };
}

export const requireAuth = async (req: AuthRequest, res: Response, next: NextFunction) => {
  const authHeader = req.headers.authorization;

  if (!authHeader?.startsWith('Bearer ')) {
    return res.status(401).json({ erro: 'Token não fornecido' });
  }

  const token = authHeader.split(' ')[1];
  const payload = await verifyAccessToken(token);

  if (!payload || !payload.sub) {
    return res.status(401).json({ erro: 'Token inválido ou expirado' });
  }

  req.user = { id: payload.sub as string };
  next();
};
