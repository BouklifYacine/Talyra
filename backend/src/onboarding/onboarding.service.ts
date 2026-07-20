import { ConflictException, Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CompleteOnboardingDto } from './dto/complete-onboarding.dto';

@Injectable()
export class OnboardingService {
  constructor(private readonly prisma: PrismaService) {}

  /**
   * Tells the frontend whether this user already belongs to a tenant.
   * Used right after login to decide: show the app, or the onboarding form.
   */
  async getStatus(userId: string) {
    const membership = await this.prisma.membership.findFirst({
      where: { userId },
      include: { tenant: true },
    });

    return {
      onboarded: membership !== null,
      tenant: membership?.tenant ?? null,
    };
  }

  /**
   * Creates the professional's business and makes them its OWNER.
   * Tenant + Membership are written in a single transaction so we never
   * end up with a tenant nobody owns.
   */
  async complete(userId: string, dto: CompleteOnboardingDto) {
    // Business rule: one owner-onboarding per user. Re-running is a conflict,
    // not a silent second tenant.
    const existing = await this.prisma.membership.findFirst({
      where: { userId },
    });
    if (existing) {
      throw new ConflictException('This account is already onboarded.');
    }

    return this.prisma.$transaction(async (tx) => {
      const tenant = await tx.tenant.create({
        data: {
          name: dto.businessName,
          businessType: dto.businessType,
          legalName: dto.legalName,
          vatMode: dto.vatMode, // undefined -> DB default (EXEMPT)
        },
      });

      await tx.membership.create({
        data: {
          tenantId: tenant.id,
          userId,
          role: 'OWNER',
        },
      });

      return tenant;
    });
  }
}
