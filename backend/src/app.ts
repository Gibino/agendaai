import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import pinoHttp from 'pino-http';
import { logger } from './lib/logger.js';
import { env } from './config/env.js';
import authRouter from './modules/auth/auth.router.js';
import categoriesRouter from './modules/categories/categories.router.js';
import companiesRouter from './modules/companies/companies.router.js';
import { notFound } from './middlewares/notFound.js';
import { errorHandler } from './middlewares/errorHandler.js';
import { globalLimiter } from './middlewares/rateLimiter.js';

const app = express();

// Middlewares
app.use(helmet());
app.use(cors({ origin: env.FRONTEND_URL ?? '*', credentials: true }));
app.use(globalLimiter);
app.use(express.json());
app.use(pinoHttp({ logger }));

// Routes
app.use('/api/v1/auth', authRouter);
app.use('/api/v1/categorias', categoriesRouter);
app.use('/api/v1/empresas', companiesRouter);

// Health check
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Middlewares (Error & 404)
app.use(notFound);
app.use(errorHandler);

// Start server
const port = parseInt(env.PORT, 10);
app.listen(port, () => {
  logger.info(`🚀 Server running on port ${port} in ${env.NODE_ENV} mode`);
});

export default app;
