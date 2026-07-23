import { Module } from '@nestjs/common';
import { TenantController } from './tenant.controller';
import { TenantService } from './tenant.service';
import { TenantGuard } from '../common/tenant/tenant.guard';

@Module({
  controllers: [TenantController],
  providers: [TenantService, TenantGuard],
  exports: [TenantGuard],
})
export class TenantModule {}
