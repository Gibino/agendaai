import { Request, Response } from 'express';
import { CompaniesService } from './companies.service.js';

const companiesService = new CompaniesService();

export const listCompanies = async (req: Request, res: Response) => {
  try {
    const { search, categoryId, skip, take } = req.query;
    
    const filters = {
      search: search as string | undefined,
      categoryId: categoryId as string | undefined,
    };
    
    const parsedSkip = skip ? parseInt(skip as string, 10) : 0;
    const parsedTake = take ? parseInt(take as string, 10) : 20;

    const result = await companiesService.list(filters, parsedSkip, parsedTake);
    res.status(200).json({ dados: result });
  } catch (error: any) {
    res.status(500).json({ erro: error.message });
  }
};

export const getCompany = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const company = await companiesService.getById(id);
    
    if (!company) {
      return res.status(404).json({ erro: 'Empresa não encontrada' });
    }

    const whatsappUrl = companiesService.getWhatsAppLink(company.phone);
    
    res.status(200).json({ 
      dados: {
        ...company,
        whatsappUrl
      }
    });
  } catch (error: any) {
    res.status(500).json({ erro: error.message });
  }
};

export const createCompany = async (req: Request, res: Response) => {
  try {
    const { name, description, phone, address, categoryId } = req.body;
    if (!name || !phone || !categoryId) {
      return res.status(400).json({ erro: 'Nome, telefone e categoryId são obrigatórios' });
    }
    const company = await companiesService.create({ name, description, phone, address, categoryId });
    res.status(201).json({ dados: company });
  } catch (error: any) {
    res.status(500).json({ erro: error.message });
  }
};

export const deleteCompany = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    await companiesService.delete(id);
    res.status(204).send();
  } catch (error: any) {
    res.status(500).json({ erro: error.message });
  }
};
