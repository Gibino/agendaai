import bcrypt from 'bcryptjs';
import { prisma } from '../../lib/prisma.js';
import { signAccessToken } from '../../lib/jwt.js';
import { randomBytes } from 'crypto';
import { sendOtp, checkOtp } from '../../lib/otp.js';
import { OAuth2Client } from 'google-auth-library';
import appleSignin from 'apple-signin-auth';
import { env } from '../../config/env.js';

const googleClient = new OAuth2Client(env.GOOGLE_CLIENT_ID);

export class AuthService {
  private async createRefreshToken(userId: string) {
    const secretPart = randomBytes(40).toString('hex');
    const rawToken = `${userId}:${secretPart}`;
    const hashedToken = await bcrypt.hash(secretPart, 10);
    
    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + 30); // 30 dias

    await prisma.refreshToken.create({
      data: {
        userId,
        token: hashedToken,
        expiresAt,
      },
    });

    return rawToken;
  }

  async renovar(rawToken: string) {
    const [userId, secretPart] = rawToken.split(':');
    if (!userId || !secretPart) {
      throw new Error('Token de renovação inválido');
    }

    const activeTokens = await prisma.refreshToken.findMany({
      where: {
        userId,
        revokedAt: null,
        expiresAt: { gt: new Date() },
      },
    });

    let validTokenRecord = null;
    for (const record of activeTokens) {
      const isValid = await bcrypt.compare(secretPart, record.token);
      if (isValid) {
        validTokenRecord = record;
        break;
      }
    }

    if (!validTokenRecord) {
      throw new Error('Token de renovação inválido ou expirado');
    }

    // Revogar token antigo
    await prisma.refreshToken.update({
      where: { id: validTokenRecord.id },
      data: { revokedAt: new Date() },
    });

    // Criar novo par de tokens
    const accessToken = await signAccessToken({ sub: userId });
    const newRefreshToken = await this.createRefreshToken(userId);

    const user = await prisma.user.findUnique({ where: { id: userId } });

    return {
      usuario: { id: user?.id, nome: user?.name, email: user?.email },
      accessToken,
      refreshToken: newRefreshToken,
    };
  }

  async sair(userId: string) {
    await prisma.refreshToken.updateMany({
      where: {
        userId,
        revokedAt: null,
      },
      data: {
        revokedAt: new Date(),
      },
    });
  }

  async registrar(nome: string, email: string, senha: string) {
    const existingUser = await prisma.user.findUnique({ where: { email } });
    if (existingUser) {
      throw new Error('E-mail já cadastrado');
    }

    const passwordHash = await bcrypt.hash(senha, 10);

    const user = await prisma.user.create({
      data: {
        name: nome,
        email,
        passwordHash,
      },
    });

    const accessToken = await signAccessToken({ sub: user.id });
    const refreshToken = await this.createRefreshToken(user.id);

    return {
      usuario: { id: user.id, nome: user.name, email: user.email },
      accessToken,
      refreshToken,
    };
  }

  async enviarCodigo(telefone: string, canal: 'SMS' | 'WHATSAPP') {
    await sendOtp(telefone, canal.toLowerCase() as 'sms' | 'whatsapp');
  }

  async verificarCodigo(telefone: string, codigo: string) {
    const isValid = await checkOtp(telefone, codigo);
    if (!isValid) {
      throw new Error('Código inválido ou expirado');
    }

    // Find or create user by phone
    let user = await prisma.user.findUnique({ where: { phone: telefone } });
    if (!user) {
      user = await prisma.user.create({
        data: {
          phone: telefone,
          phoneVerified: true,
        },
      });
    } else if (!user.phoneVerified) {
      user = await prisma.user.update({
        where: { id: user.id },
        data: { phoneVerified: true },
      });
    }

    const accessToken = await signAccessToken({ sub: user.id });
    const refreshToken = await this.createRefreshToken(user.id);

    return {
      usuario: { id: user.id, nome: user.name, email: user.email, telefone: user.phone },
      accessToken,
      refreshToken,
    };
  }

  async login(email: string, senha: string) {
    const user = await prisma.user.findUnique({ where: { email } });
    if (!user || !user.passwordHash) {
      throw new Error('Credenciais inválidas');
    }

    const isPasswordValid = await bcrypt.compare(senha, user.passwordHash);
    if (!isPasswordValid) {
      throw new Error('Credenciais inválidas');
    }

    const accessToken = await signAccessToken({ sub: user.id });
    const refreshToken = await this.createRefreshToken(user.id);

    return {
      usuario: { id: user.id, nome: user.name, email: user.email },
      accessToken,
      refreshToken,
    };
  }

  async googleAuth(idToken: string) {
    if (!env.GOOGLE_CLIENT_ID) {
      throw new Error('Google Login não configurado');
    }

    const ticket = await googleClient.verifyIdToken({
      idToken,
      audience: env.GOOGLE_CLIENT_ID,
    });
    const payload = ticket.getPayload();
    
    if (!payload || !payload.email || !payload.sub) {
      throw new Error('Token Google inválido');
    }

    let user = await prisma.user.findUnique({ where: { googleId: payload.sub } });
    if (!user) {
      user = await prisma.user.findUnique({ where: { email: payload.email } });
      if (user) {
        user = await prisma.user.update({
          where: { id: user.id },
          data: { googleId: payload.sub, emailVerified: payload.email_verified },
        });
      } else {
        user = await prisma.user.create({
          data: {
            email: payload.email,
            name: payload.name,
            googleId: payload.sub,
            emailVerified: payload.email_verified,
            avatarUrl: payload.picture,
          },
        });
      }
    }

    const accessToken = await signAccessToken({ sub: user.id });
    const refreshToken = await this.createRefreshToken(user.id);

    return {
      usuario: { id: user.id, nome: user.name, email: user.email },
      accessToken,
      refreshToken,
    };
  }

  async appleAuth(idToken: string) {
    try {
      const payload = await appleSignin.verifyIdToken(idToken, {
        audience: env.APPLE_CLIENT_ID,
        ignoreExpiration: true,
      });

      if (!payload || !payload.sub) {
        throw new Error('Token Apple inválido');
      }

      let user = await prisma.user.findUnique({ where: { appleId: payload.sub } });
      
      if (!user) {
        // Since we don't have email guaranteed after the first login via apple,
        // we'll rely on appleId as primary if they didn't link email on first creation.
        user = await prisma.user.create({
          data: {
            appleId: payload.sub,
            // email should be handled differently if payload.email exists, but for simplicity here:
          },
        });
      }

      const accessToken = await signAccessToken({ sub: user.id });
      const refreshToken = await this.createRefreshToken(user.id);

      return {
        usuario: { id: user.id, nome: user.name, email: user.email },
        accessToken,
        refreshToken,
      };
    } catch (err: any) {
      throw new Error(`Erro no login Apple: ${err.message}`);
    }
  }
}
