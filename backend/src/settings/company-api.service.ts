import {
  Injectable,
  NotFoundException,
  ServiceUnavailableException,
} from '@nestjs/common';
import { ofetch } from 'ofetch';
import { LegalForm } from '../generated/prisma/enums';

interface CompanySearchResponse {
  results: Array<{
    siren: string;
    nom_complet: string;
    nom_raison_sociale: string | null;
    etat_administratif: string;
    nature_juridique: string;
    tva?: string[];
    siege: {
      complement_adresse?: string | null;
      numero_voie?: string | null;
      indice_repetition?: string | null;
      type_voie?: string | null;
      libelle_voie?: string | null;
      code_postal?: string | null;
      libelle_commune?: string | null;
    };
  }>;
}

@Injectable()
export class CompanyApiService {
  private readonly api = ofetch.create({
    baseURL: 'https://recherche-entreprises.api.gouv.fr',
    headers: {
      Accept: 'application/json',
      'User-Agent': 'Talyra/1.0',
    },
    timeout: 5000,
    retry: 1,
  });

  async findBySiren(siren: string) {
    let data: CompanySearchResponse;

    try {
      data = await this.api<CompanySearchResponse>('/search', {
        query: {
          q: siren,
          minimal: true,
          include: 'siege,tva',
          per_page: 1,
        },
      });
    } catch {
      throw new ServiceUnavailableException(
        'La vérification du SIREN est temporairement indisponible.',
      );
    }

    const company = data.results[0];

    if (!company || company.siren !== siren) {
      throw new NotFoundException('Aucune entreprise trouvée pour ce SIREN.');
    }

    const addressLine1 = [
      company.siege.numero_voie,
      company.siege.indice_repetition,
      company.siege.type_voie,
      company.siege.libelle_voie,
    ]
      .filter(Boolean)
      .join(' ');

    return {
      siren: company.siren,
      legalName: company.nom_raison_sociale ?? company.nom_complet,
      legalForm: company.nature_juridique === '1000' ? LegalForm.EI : null,
      legalAddressLine1: addressLine1 || null,
      legalAddressLine2: company.siege.complement_adresse ?? null,
      legalPostalCode: company.siege.code_postal ?? null,
      legalCity: company.siege.libelle_commune ?? null,
      vatNumber: company.tva?.[0] ?? null,
      active: company.etat_administratif === 'A',
    };
  }
}
