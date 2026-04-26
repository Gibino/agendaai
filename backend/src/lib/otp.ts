import twilio from 'twilio';
import { env } from '../config/env.js';
import { logger } from './logger.js';

let client: twilio.Twilio | null = null;

if (env.TWILIO_ENABLED === 'true' && env.TWILIO_ACCOUNT_SID && env.TWILIO_AUTH_TOKEN) {
  client = twilio(env.TWILIO_ACCOUNT_SID, env.TWILIO_AUTH_TOKEN);
}

export async function sendOtp(phone: string, channel: 'sms' | 'whatsapp') {
  if (env.TWILIO_ENABLED !== 'true' || !client || !env.TWILIO_VERIFY_SERVICE_SID) {
    logger.info(`[MOCK OTP] Enviando código para ${phone} via ${channel} (código aceito: 123456)`);
    return;
  }

  // Prepend country code if missing (assumes Brazilian +55 for now based on MVP)
  const to = phone.startsWith('+') ? phone : `+55${phone}`;

  await client.verify.v2.services(env.TWILIO_VERIFY_SERVICE_SID).verifications.create({
    to,
    channel,
  });
}

export async function checkOtp(phone: string, code: string): Promise<boolean> {
  if (env.TWILIO_ENABLED !== 'true' || !client || !env.TWILIO_VERIFY_SERVICE_SID) {
    logger.info(`[MOCK OTP] Verificando código ${code} para ${phone}`);
    return code === '123456';
  }

  const to = phone.startsWith('+') ? phone : `+55${phone}`;

  try {
    const verification = await client.verify.v2.services(env.TWILIO_VERIFY_SERVICE_SID).verificationChecks.create({
      to,
      code,
    });
    return verification.status === 'approved';
  } catch (error) {
    logger.error({ error }, 'Erro ao verificar OTP no Twilio');
    return false;
  }
}
