import { Body, Controller, Get, Param, Patch, UseGuards } from '@nestjs/common';
import { CurrentTenant } from '../common/tenant/current-tenant.decorator';
import { TenantGuard } from '../common/tenant/tenant.guard';
import { CompanyApiService } from './company-api.service';
import { SirenParamDto } from './dto/siren-param.dto';
import { UpdateBusinessSettingsDto } from './dto/update-business-settings.dto';
import { SettingsService } from './settings.service';

@Controller('settings/business')
@UseGuards(TenantGuard)
export class SettingsController {
  constructor(
    private readonly settingsService: SettingsService,
    private readonly companyApiService: CompanyApiService,
  ) {}

  @Get()
  getBusinessSettings(@CurrentTenant() tenantId: string) {
    return this.settingsService.getBusinessSettings(tenantId);
  }

  @Get('siren/:siren')
  findCompanyBySiren(@Param() params: SirenParamDto) {
    return this.companyApiService.findBySiren(params.siren);
  }

  @Patch()
  updateBusinessSettings(
    @CurrentTenant() tenantId: string,
    @Body() dto: UpdateBusinessSettingsDto,
  ) {
    return this.settingsService.updateBusinessSettings(tenantId, dto);
  }
}
