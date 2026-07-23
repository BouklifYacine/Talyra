import { Body, Controller, Get, Patch, UseGuards } from '@nestjs/common';
import { CurrentTenant } from '../common/tenant/current-tenant.decorator';
import { TenantGuard } from '../common/tenant/tenant.guard';
import { UpdateBusinessSettingsDto } from './dto/update-business-settings.dto';
import { SettingsService } from './settings.service';

@Controller('settings/business')
@UseGuards(TenantGuard)
export class SettingsController {
  constructor(private readonly settingsService: SettingsService) {}

  @Get()
  getBusinessSettings(@CurrentTenant() tenantId: string) {
    return this.settingsService.getBusinessSettings(tenantId);
  }

  @Patch()
  updateBusinessSettings(
    @CurrentTenant() tenantId: string,
    @Body() dto: UpdateBusinessSettingsDto,
  ) {
    return this.settingsService.updateBusinessSettings(tenantId, dto);
  }
}
