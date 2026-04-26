# Agenda AI — Backend

Este é o backend do sistema **Agenda AI**, um serviço de diretório de serviços para pequenas empresas (cabeleireiros, mecânicos, alfaiates, etc.).

## 🚀 Tecnologias

- **Node.js 20+** com **TypeScript**
- **Express** (Framework Web)
- **Prisma** (ORM) com **PostgreSQL**
- **Zod** (Validação de schemas)
- **Jose** (JWT para autenticação)
- **Pino** (Logging estruturado)
- **Vitest & Supertest** (Testes)
- **Docker** (Containerização)

## 🛠️ Módulos e Funcionalidades

- **Autenticação** (`/api/v1/auth`)**:**
  - Login e registro via E-mail/Senha.
  - Login via Telefone (OTP SMS/WhatsApp via Twilio).
  - Social Login (Google e Apple).
  - Rotação de Refresh Tokens (com hash de segurança).
- **Diretório** (`/api/v1/empresas`)**:**
  - Busca e filtragem de empresas por nome e categoria.
  - Geração automática de links para WhatsApp das empresas.
- **Categorias** (`/api/v1/categorias`)**:**
  - Listagem pública de categorias de serviço.
- **Banners** (`/api/v1/banners`)**:**
  - Listagem pública de banners ativos (carrossel da home).
  - CRUD admin para gerenciar título, imagem e link do banner.
- **Promoções** (`/api/v1/promocoes`)**:**
  - Listagem pública de promoções ativas no período atual.
  - CRUD admin para criar e gerenciar promoções vinculadas a empresas.
- **Segurança:**
  - Rate limiting (Global e específico para Auth).
  - CORS configurável via variável de ambiente.
  - Helmet para headers de segurança.

## ⚙️ Configuração

1. Instale as dependências:
   ```bash
   npm install
   ```

2. Configure as variáveis de ambiente:
   - Copie o `.env.example` para `.env`.
   - Preencha `DATABASE_URL`, `JWT_SECRET`, e `ADMIN_KEY`.

3. Prepare o banco de dados:
   ```bash
   npx prisma migrate dev
   npx prisma db seed
   ```

4. Inicie o servidor:
   ```bash
   npm run dev
   ```

## 🧪 Testes

Execute os testes unitários e de integração:
```bash
npm run test
```

## 🐳 Docker

Para rodar via Docker:
```bash
docker build -t agenda-ai-backend .
docker run -p 3000:3000 agenda-ai-backend
```
