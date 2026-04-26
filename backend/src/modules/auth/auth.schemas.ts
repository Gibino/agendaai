import { z } from 'zod';

export const registerSchema = z.object({
  nome: z.string().min(2),
  email: z.string().email(),
  senha: z.string().min(6),
});

export const loginSchema = z.object({
  email: z.string().email(),
  senha: z.string(),
});

export const phoneOtpRequestSchema = z.object({
  telefone: z.string().regex(/^\d{10,11}$/, 'Telefone deve ter 10 ou 11 dígitos'),
  canal: z.enum(['SMS', 'WHATSAPP']),
});

export const phoneOtpVerifySchema = z.object({
  telefone: z.string(),
  codigo: z.string().length(6),
});

export const googleAuthSchema = z.object({
  idToken: z.string(),
});

export const appleAuthSchema = z.object({
  idToken: z.string(),
  authorizationCode: z.string().optional(),
});
