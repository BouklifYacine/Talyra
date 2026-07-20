import { IsEnum, IsOptional, IsString, MaxLength, MinLength } from 'class-validator';
import { BusinessType, VatMode } from '../../generated/prisma/enums';

/**
 * The payload a freshly signed-up professional sends to create their business.
 * Every field here is validated by the global ValidationPipe before the
 * controller ever runs — the service can trust this data is well-formed.
 */
export class CompleteOnboardingDto {
  @IsString()
  @MinLength(2)
  @MaxLength(120)
  businessName!: string;

  @IsEnum(BusinessType)
  businessType!: BusinessType;

  @IsOptional()
  @IsString()
  @MaxLength(200)
  legalName?: string;

  @IsOptional()
  @IsEnum(VatMode)
  vatMode?: VatMode;
}
