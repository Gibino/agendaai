# 🗓️ Agenda-AI

> **A modern directory and scheduling service platform designed for small businesses.**

Agenda-AI connects service providers (hairdressers, mechanics, tailors, etc.) with their customers through a streamlined, secure, and user-friendly ecosystem.

---

## 🌟 Key Features

- **🔍 Smart Directory:** Effortless search and filtering of local businesses by category.
- **🔐 Multi-channel Authentication:**
  - **Social Login:** Seamless integration with **Google** and **Apple**.
  - **Passwordless:** Secure OTP via SMS/WhatsApp through **Twilio**.
  - **Traditional:** Standard Email/Password registration.
- **🛡️ Enterprise-Grade Security:** 
  - Token rotation, global rate limiting, and protection via `Helmet` and `CORS`.
- **⚡ Performance Optimized:** Built on **Express 5** and **Prisma ORM** for ultra-fast response times.
- **🐳 Cloud Ready:** Fully containerized with **Docker**, ready for GCP Cloud Run or any cloud provider.

---

## 🏗️ Project Structure

| Directory | Description | Status |
| :--- | :--- | :--- |
| [`backend/`](./backend) | Node.js API with TypeScript, Prisma, and PostgreSQL | **Production Ready** |
| [`frontend/`](./frontend) | React/Next.js Web Application | *Coming Soon* |

---

## 🛠️ Tech Stack

### Backend Core
- **Language:** TypeScript
- **Runtime:** Node.js 20+
- **Framework:** Express (v5.x)
- **Database:** PostgreSQL via Prisma ORM
- **Authentication:** JWT (Jose), Bcrypt.js
- **Logging:** Pino & Morgan
- **Validation:** Zod

### Security & DevOps
- **Security:** Helmet, Express Rate Limit
- **Testing:** Vitest, Supertest
- **Infrastructure:** Docker

---

## 🚀 Getting Started (Backend)

### Prerequisites
- Node.js 20+
- PostgreSQL instance (or Docker)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Gibino/agendaai.git
   cd agendaai
   ```

2. **Setup Backend:**
   ```bash
   cd backend
   npm install
   ```

3. **Environment Configuration:**
   Copy `.env.example` to `.env` and fill in your credentials:
   ```bash
   cp .env.example .env
   ```

4. **Initialize Database:**
   ```bash
   npx prisma migrate dev
   npx prisma db seed
   ```

5. **Run the server:**
   ```bash
   npm run dev
   ```

---

## 🧪 Testing

Run unit and integration tests to ensure system stability:
```bash
npm run test
```

---

## 📄 License

This project is licensed under the MIT License.

---
*Developed with ❤️ by [Marcos Gibin](https://github.com/Gibino)*
