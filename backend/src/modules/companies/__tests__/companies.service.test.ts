import { describe, it, expect, vi } from 'vitest';
import { CompaniesService } from '../companies.service.js';

vi.mock('../../../lib/prisma.js', () => ({
  prisma: {
    company: { findMany: vi.fn(), count: vi.fn() }
  }
}));

describe('CompaniesService', () => {
  const service = new CompaniesService();

  describe('getWhatsAppLink', () => {
    it('deve gerar link correto com prefixo 55 para números sem prefixo', () => {
      const link = service.getWhatsAppLink('11999998888');
      expect(link).toContain('https://wa.me/5511999998888');
      expect(link).toContain('?text=Ol%C3%A1!%20Encontrei%20voc%C3%AA%20no%20Agenda%20AI.');
    });

    it('deve manter o prefixo 55 se já existir', () => {
      const link = service.getWhatsAppLink('5511999998888');
      expect(link).toContain('https://wa.me/5511999998888');
    });

    it('deve remover caracteres não numéricos', () => {
      const link = service.getWhatsAppLink('(11) 99999-8888');
      expect(link).toContain('https://wa.me/5511999998888');
    });
  });
});
