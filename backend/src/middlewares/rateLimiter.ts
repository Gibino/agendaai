import rateLimit from 'express-rate-limit';

export const globalLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutos
  max: 100, // limite de 100 requisições por IP
  message: { erro: 'Muitas requisições, por favor tente novamente mais tarde.' },
  standardHeaders: true,
  legacyHeaders: false,
});

export const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutos
  max: 10, // limite de 10 tentativas por IP
  message: { erro: 'Muitas tentativas de login/registro, por favor tente novamente em 15 minutos.' },
  standardHeaders: true,
  legacyHeaders: false,
});
