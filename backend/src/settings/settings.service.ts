import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { UpdateBusinessSettingsDto } from './dto/update-business-settings.dto';

@Injectable()
export class SettingsService {
  constructor(private readonly prisma: PrismaService) {}

  getBusinessSettings(tenantId: string) {
    return this.prisma.tenant.findUnique({
      where: { id: tenantId },
    });
  }

  updateBusinessSettings(tenantId: string, dto: UpdateBusinessSettingsDto) {
    const { businessName, ...data } = dto;

    return this.prisma.tenant.update({
      where: { id: tenantId },
      data: {
        ...data,
        ...(businessName !== undefined && { name: businessName }),
      },
    });
  }
}
