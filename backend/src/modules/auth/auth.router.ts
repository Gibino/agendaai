import { Router } from 'express';
import { registrar, login, renovar, sair, enviarCodigo, verificarCodigo, googleAuth, appleAuth } from './auth.controller.js';
import { requireAuth } from '../../middlewares/requireAuth.js';
import { authLimiter } from '../../middlewares/rateLimiter.js';
import { prisma } from '../../lib/prisma.js';

const router = Router();

router.post('/registrar', authLimiter, registrar);
router.post('/login', authLimiter, login);
router.post('/renovar', authLimiter, renovar);
router.post('/sair', requireAuth, sair);

router.post('/telefone/enviar-codigo', authLimiter, enviarCodigo);
router.post('/telefone/verificar', authLimiter, verificarCodigo);

router.post('/google', authLimiter, googleAuth);
router.post('/apple', authLimiter, appleAuth);

router.get('/me', requireAuth, async (req: any, res) => {
  const user = await prisma.user.findUnique({
    where: { id: req.user.id },
    select: { id: true, name: true, email: true, phone: true, avatarUrl: true },
  });
  res.json({ dados: { usuario: user } });
});

export default router;
