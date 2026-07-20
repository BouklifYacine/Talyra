import { Body, Controller, Get, Post } from '@nestjs/common';
import { Session, type UserSession } from '@thallesp/nestjs-better-auth';
import { auth } from '../auth';
import { CompleteOnboardingDto } from './dto/complete-onboarding.dto';
import { OnboardingService } from './onboarding.service';

@Controller('onboarding')
export class OnboardingController {
  constructor(private readonly onboarding: OnboardingService) {}

  /** GET /onboarding/status — has this user completed onboarding yet? */
  @Get('status')
  getStatus(@Session() session: UserSession<typeof auth>) {
    return this.onboarding.getStatus(session.user.id);
  }

  /** POST /onboarding — create the business and become its owner. */
  @Post()
  complete(
    @Session() session: UserSession<typeof auth>,
    @Body() dto: CompleteOnboardingDto,
  ) {
    return this.onboarding.complete(session.user.id, dto);
  }
}
