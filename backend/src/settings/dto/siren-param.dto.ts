import { Matches } from 'class-validator';

export class SirenParamDto {
  @Matches(/^\d{9}$/, {
    message: 'Le SIREN doit contenir exactement 9 chiffres.',
  })
  siren!: string;
}
