import { IsEnum, IsString, MaxLength, MinLength } from 'class-validator';
import { BusinessType } from '../../generated/prisma/enums';

export class CreateTenantDto {
  @IsString()
  @MinLength(2)
  @MaxLength(120)
  businessName!: string;

  @IsEnum(BusinessType, {
    message:
      "Le type d'activité doit être : DECORATRICE, NEGAFA, WEDDING PLANNER ou PHOTO-VIDEO.",
  })
  businessType!: BusinessType;
}
