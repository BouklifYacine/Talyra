import { ValidationPipe } from '@nestjs/common';
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
  // Validates every incoming DTO against its class-validator decorators.
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true, // drop properties not declared in the DTO
      forbidNonWhitelisted: true, // 400 if the client sends unknown properties
      transform: true, // turn the plain JSON body into a real DTO instance
    }),
  );
  await app.listen(process.env.PORT ?? 3001);
}
bootstrap();
