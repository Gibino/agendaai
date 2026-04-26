import request from 'supertest';
import { describe, it, expect, vi } from 'vitest';

vi.mock('../../../lib/prisma.js', () => ({
  prisma: {
    category: { findMany: vi.fn().mockResolvedValue([]) },
    user: { findUnique: vi.fn() }
  }
}));

import app from '../../../app.js';

describe('Integração Básica', () => {
  describe('GET /health', () => {
    it('deve retornar 200 OK', async () => {
      const response = await request(app).get('/health');
      expect(response.status).toBe(200);
      expect(response.body.status).toBe('ok');
    });
  });

  describe('Global Rate Limiter', () => {
    it('deve permitir requisições normais', async () => {
      const response = await request(app).get('/health');
      expect(response.status).toBe(200);
    });
  });
});
