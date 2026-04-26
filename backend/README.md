# Agenda AI - Backend MVP

Este é o backend do sistema **Agenda AI**, um serviço de diretório e agendamento para pequenas empresas (cabeleireiros, mecânicos, alfaiates, etc.).

## 🚀 Tecnologias

- **Node.js 20+** com **TypeScript**
- **Express** (Framework Web)
- **Prisma** (ORM) com **PostgreSQL**
- **Zod** (Validação de schemas)
- **Jose** (JWT para autenticação)
- **Pino** (Logging estruturado)
- **Vitest & Supertest** (Testes)
- **Docker** (Containerização)

## 🛠️ Funcionalidades Principais

- **Autenticação:**
  - Login e registro via E-mail/Senha.
  - Login via Telefone (OTP SMS/WhatsApp via Twilio).
  - Social Login (Google e Apple).
  - Rotação de Refresh Tokens (com hash de segurança).
- **Diretório:**
  - Busca e filtragem de empresas por categoria.
  - Geração automática de links para WhatsApp das empresas.
- **Admin:**
  - Middleware de proteção via Admin Key.
  - CRUD de categorias e empresas (exclusivo para admins no MVP).
- **Segurança:**
  - Rate limiting (Global e específico para Auth).
  - CORS configurável.
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
# agenda-ai
# agenda-ai
