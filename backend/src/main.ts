// Must run before any other import: auth.ts reads process.env.DATABASE_URL
// at module-load time, so .env has to be loaded first.
import 'dotenv/config';

import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, {
    // Better Auth needs the raw request body; this module re-adds body
    // parsers for every non-auth route (see @thallesp/nestjs-better-auth).
    bodyParser: false,
  });
  app.enableCors({
    origin: process.env.FRONTEND_URL ?? 'http://localhost:3000',
    credentials: true,
  });
  await app.listen(process.env.PORT ?? 3001);
}
bootstrap();
