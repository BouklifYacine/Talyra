import { Type } from 'class-transformer';
import { PartialType } from '@nestjs/mapped-types';
import {
  IsEmail,
  IsEnum,
  IsIn,
  IsInt,
  IsOptional,
  IsString,
  Matches,
  MaxLength,
  Min,
} from 'class-validator';
import { LegalForm, VatMode } from '../../generated/prisma/enums';
import { CreateTenantDto } from '../../tenant/dto/create-tenant.dto';

export class UpdateBusinessSettingsDto extends PartialType(CreateTenantDto) {
  @IsOptional()
  @IsEmail()
  email?: string | null;

  @IsOptional()
  @Matches(/^\+?[0-9]{8,15}$/)
  phone?: string | null;

  @IsOptional()
  @IsString()
  @MaxLength(160)
  legalName?: string | null;

  @IsOptional()
  @Matches(/^\d{9}$/)
  siren?: string | null;

  @IsOptional()
  @IsEnum(LegalForm)
  legalForm?: LegalForm | null;

  @IsOptional()
  @IsString()
  @MaxLength(50)
  legalFormOther?: string | null;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  shareCapitalCents?: number | null;

  @IsOptional()
  @IsString()
  @MaxLength(160)
  legalAddressLine1?: string | null;

  @IsOptional()
  @IsString()
  @MaxLength(160)
  legalAddressLine2?: string | null;

  @IsOptional()
  @Matches(/^\d{5}$/)
  legalPostalCode?: string | null;

  @IsOptional()
  @IsString()
  @MaxLength(100)
  legalCity?: string | null;

  @IsOptional()
  @IsIn(['FR'])
  legalCountryCode?: 'FR';

  @IsOptional()
  @IsEnum(VatMode)
  vatMode?: VatMode | null;

  @IsOptional()
  @Matches(/^FR[A-Z0-9]{2}\d{9}$/)
  vatNumber?: string | null;
}
