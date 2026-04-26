import { Request, Response } from 'express';
import { AuthService } from './auth.service.js';
import { registerSchema, loginSchema, phoneOtpRequestSchema, phoneOtpVerifySchema, googleAuthSchema, appleAuthSchema } from './auth.schemas.js';

const authService = new AuthService();

export const registrar = async (req: Request, res: Response) => {
  try {
    const body = registerSchema.parse(req.body);
    const result = await authService.registrar(body.nome, body.email, body.senha);
    res.status(201).json({ dados: result });
  } catch (error: any) {
    res.status(400).json({ erro: error.message });
  }
};

export const login = async (req: Request, res: Response) => {
  try {
    const body = loginSchema.parse(req.body);
    const result = await authService.login(body.email, body.senha);
    res.status(200).json({ dados: result });
  } catch (error: any) {
    res.status(401).json({ erro: error.message });
  }
};

export const renovar = async (req: Request, res: Response) => {
  try {
    const { refreshToken } = req.body;
    if (!refreshToken) {
      return res.status(400).json({ erro: 'Refresh token não fornecido' });
    }
    const result = await authService.renovar(refreshToken);
    res.status(200).json({ dados: result });
  } catch (error: any) {
    res.status(401).json({ erro: error.message });
  }
};

export const sair = async (req: any, res: Response) => {
  try {
    await authService.sair(req.user.id);
    res.status(204).send();
  } catch (error: any) {
    res.status(500).json({ erro: error.message });
  }
};

export const enviarCodigo = async (req: Request, res: Response) => {
  try {
    const body = phoneOtpRequestSchema.parse(req.body);
    await authService.enviarCodigo(body.telefone, body.canal);
    res.status(200).json({ mensagem: 'Código enviado com sucesso.' });
  } catch (error: any) {
    res.status(400).json({ erro: error.message });
  }
};

export const verificarCodigo = async (req: Request, res: Response) => {
  try {
    const body = phoneOtpVerifySchema.parse(req.body);
    const result = await authService.verificarCodigo(body.telefone, body.codigo);
    res.status(200).json({ dados: result });
  } catch (error: any) {
    res.status(401).json({ erro: error.message });
  }
};

export const googleAuth = async (req: Request, res: Response) => {
  try {
    const body = googleAuthSchema.parse(req.body);
    const result = await authService.googleAuth(body.idToken);
    res.status(200).json({ dados: result });
  } catch (error: any) {
    res.status(401).json({ erro: error.message });
  }
};

export const appleAuth = async (req: Request, res: Response) => {
  try {
    const body = appleAuthSchema.parse(req.body);
    const result = await authService.appleAuth(body.idToken);
    res.status(200).json({ dados: result });
  } catch (error: any) {
    res.status(401).json({ erro: error.message });
  }
};
