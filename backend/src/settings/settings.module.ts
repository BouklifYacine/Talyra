import { Module } from '@nestjs/common';
import { TenantModule } from '../tenant/tenant.module';
import { CompanyApiService } from './company-api.service';
import { SettingsController } from './settings.controller';
import { SettingsService } from './settings.service';

@Module({
  imports: [TenantModule],
  controllers: [SettingsController],
  providers: [SettingsService, CompanyApiService],
})
export class SettingsModule {}
