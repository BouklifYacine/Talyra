-- AlterTable
ALTER TABLE "tenant" ADD COLUMN     "legal_address_line_1" TEXT,
ADD COLUMN     "legal_address_line_2" TEXT,
ADD COLUMN     "legal_city" TEXT,
ADD COLUMN     "legal_country_code" TEXT NOT NULL DEFAULT 'FR',
ADD COLUMN     "legal_postal_code" TEXT,
ADD COLUMN     "phone" TEXT,
ADD COLUMN     "siren" TEXT,
ADD COLUMN     "vat_number" TEXT;
