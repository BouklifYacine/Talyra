-- CreateEnum
CREATE TYPE "LegalForm" AS ENUM ('EI', 'SASU', 'EURL', 'OTHER');

-- AlterTable
ALTER TABLE "tenant" ADD COLUMN     "legal_form" "LegalForm",
ADD COLUMN     "legal_form_other" TEXT,
ADD COLUMN     "share_capital_cents" INTEGER,
ALTER COLUMN "vatMode" DROP NOT NULL,
ALTER COLUMN "vatMode" DROP DEFAULT,
ALTER COLUMN "siren" SET DATA TYPE VARCHAR(9);

-- Existing EXEMPT values came from the former database default, not from an
-- explicit user choice. Force the progressive profile to ask the question.
UPDATE "tenant" SET "vatMode" = NULL;

-- CreateTable
CREATE TABLE "activity_log" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT NOT NULL,
    "actor_id" TEXT,
    "type" TEXT NOT NULL,
    "target_type" TEXT NOT NULL,
    "target_id" TEXT NOT NULL,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "activity_log_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "activity_log_tenant_id_createdAt_idx" ON "activity_log"("tenant_id", "createdAt");

-- CreateIndex
CREATE INDEX "activity_log_target_type_target_id_idx" ON "activity_log"("target_type", "target_id");

-- CreateIndex
CREATE UNIQUE INDEX "tenant_siren_key" ON "tenant"("siren");

-- AddForeignKey
ALTER TABLE "activity_log" ADD CONSTRAINT "activity_log_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "activity_log" ADD CONSTRAINT "activity_log_actor_id_fkey" FOREIGN KEY ("actor_id") REFERENCES "user"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- ActivityLog is tenant-owned and must fail closed without a transaction-local
-- app.tenant_id context.
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE "activity_log" TO talyra_app;
ALTER TABLE "activity_log" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "activity_log" FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON "activity_log"
USING (tenant_id = current_setting('app.tenant_id', true))
WITH CHECK (tenant_id = current_setting('app.tenant_id', true));
