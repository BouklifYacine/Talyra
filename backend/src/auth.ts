import 'dotenv/config';

import { betterAuth } from 'better-auth';
import { prismaAdapter } from 'better-auth/adapters/prisma';
import { PrismaPg } from '@prisma/adapter-pg';
import { PrismaClient } from './generated/prisma/client';

const prisma = new PrismaClient({
  adapter: new PrismaPg({ connectionString: process.env.DATABASE_URL }),
});

const trustedOrigins = [
  process.env.FRONTEND_URL ?? 'http://localhost:3000',
  process.env.BETTER_AUTH_URL ?? 'http://localhost:3001',
];

export const auth = betterAuth({
  appName: 'Talyra',
  database: prismaAdapter(prisma, { provider: 'postgresql' }),
  emailAndPassword: {
    enabled: true,
    minPasswordLength: 6,
    maxPasswordLength: 128,
  },
  rateLimit: {
    enabled: true,
    window: 60,
    max: 10,
    customRules: {
      '/sign-up/email': { window: 60, max: 5 },
      '/sign-in/email': { window: 60, max: 5 },
    },
  },
  trustedOrigins,
});
