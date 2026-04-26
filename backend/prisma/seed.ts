import { PrismaClient } from '@prisma/client';
const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Iniciando o seed...');

  await prisma.company.deleteMany({});
  await prisma.category.deleteMany({});

  const categorias = [
    { name: 'Beleza', description: 'Cabeleireiros, Manicures, Estética', icon: 'Scissors' },
    { name: 'Serviços Automotivos', description: 'Mecânicas, Funilaria, Lava rápido', icon: 'Car' },
    { name: 'Vestuário', description: 'Alfaiates, Costureiras, Lojas', icon: 'Shirt' },
    { name: 'Saúde', description: 'Dentistas, Fisioterapeutas, Clínicas', icon: 'HeartPulse' },
    { name: 'Aulas', description: 'Professores particulares, Idiomas, Música', icon: 'GraduationCap' },
  ];

  console.log('Criando categorias...');
  const criadas = [];
  for (const c of categorias) {
    const cat = await prisma.category.create({ data: c });
    criadas.push(cat);
  }

  const belezaId = criadas.find((c) => c.name === 'Beleza')!.id;
  const autoId = criadas.find((c) => c.name === 'Serviços Automotivos')!.id;
  const vestId = criadas.find((c) => c.name === 'Vestuário')!.id;
  const saudeId = criadas.find((c) => c.name === 'Saúde')!.id;
  const aulasId = criadas.find((c) => c.name === 'Aulas')!.id;

  const empresas = [
    { name: 'Salão da Maria', description: 'Cortes femininos e masculinos.', phone: '11999991111', categoryId: belezaId },
    { name: 'Barbearia do Zé', description: 'Corte de cabelo e barba.', phone: '11999991112', categoryId: belezaId },
    { name: 'Estética Avançada', description: 'Limpeza de pele e massagens.', phone: '11999991113', categoryId: belezaId },
    { name: 'Manicure Express', description: 'Unhas decoradas e spa dos pés.', phone: '11999991114', categoryId: belezaId },

    { name: 'Mecânica Confiança', description: 'Revisão geral e motor.', phone: '11999992221', categoryId: autoId },
    { name: 'Borracharia 24h', description: 'Troca e conserto de pneus.', phone: '11999992222', categoryId: autoId },
    { name: 'Lava Rápido Brilho', description: 'Lavagem completa com cera.', phone: '11999992223', categoryId: autoId },
    { name: 'Auto Elétrica Luz', description: 'Baterias e sistemas elétricos.', phone: '11999992224', categoryId: autoId },

    { name: 'Costureira da Esquina', description: 'Ajustes e consertos em geral.', phone: '11999993331', categoryId: vestId },
    { name: 'Alfaiataria Fina', description: 'Ternos sob medida.', phone: '11999993332', categoryId: vestId },
    { name: 'Ateliê dos Vestidos', description: 'Vestidos de festa e noiva.', phone: '11999993333', categoryId: vestId },
    { name: 'Consertos Rápidos', description: 'Bainha e troca de zíper.', phone: '11999993334', categoryId: vestId },

    { name: 'Clínica Sorriso', description: 'Odontologia geral e ortodontia.', phone: '11999994441', categoryId: saudeId },
    { name: 'Fisio Vida', description: 'Fisioterapia e pilates.', phone: '11999994442', categoryId: saudeId },
    { name: 'Psicologia em Foco', description: 'Terapia individual e casais.', phone: '11999994443', categoryId: saudeId },
    { name: 'Nutrição Equilíbrio', description: 'Dietas personalizadas.', phone: '11999994444', categoryId: saudeId },

    { name: 'Inglês Rápido', description: 'Aulas de inglês para negócios.', phone: '11999995551', categoryId: aulasId },
    { name: 'Música para Todos', description: 'Aulas de violão e canto.', phone: '11999995552', categoryId: aulasId },
    { name: 'Reforço Escolar', description: 'Matemática e física.', phone: '11999995553', categoryId: aulasId },
    { name: 'Aulas de Dança', description: 'Samba, forró e ritmos.', phone: '11999995554', categoryId: aulasId },
  ];

  console.log('Criando empresas...');
  await prisma.company.createMany({
    data: empresas,
  });

  console.log('✅ Seed finalizado com sucesso!');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
