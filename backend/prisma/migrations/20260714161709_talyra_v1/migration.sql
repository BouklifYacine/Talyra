-- CreateEnum
CREATE TYPE "TenantPlan" AS ENUM ('TRIAL', 'STARTER', 'PRO', 'STUDIO');

-- CreateEnum
CREATE TYPE "TenantStatus" AS ENUM ('ACTIVE', 'SUSPENDED');

-- CreateEnum
CREATE TYPE "VatMode" AS ENUM ('EXEMPT', 'STANDARD');

-- CreateEnum
CREATE TYPE "MembershipRole" AS ENUM ('OWNER', 'MEMBER');

-- CreateEnum
CREATE TYPE "LeadStage" AS ENUM ('NEW', 'QUALIFIED', 'PROPOSAL', 'WON', 'LOST');

-- CreateEnum
CREATE TYPE "PrestationStatus" AS ENUM ('DRAFT', 'OPTION', 'CONFIRMED', 'CANCELLED', 'POSTPONED');

-- CreateEnum
CREATE TYPE "BookingStatus" AS ENUM ('OPTION', 'CONFIRMED', 'CANCELLED', 'POSTPONED');

-- CreateEnum
CREATE TYPE "OptionHoldStatus" AS ENUM ('ACTIVE', 'EXPIRED', 'RELEASED');

-- CreateEnum
CREATE TYPE "QuoteStatus" AS ENUM ('DRAFT', 'SENT', 'ACCEPTED', 'EXPIRED', 'DECLINED');

-- CreateEnum
CREATE TYPE "ContractStatus" AS ENUM ('DRAFT', 'SENT', 'SIGNED', 'VOID');

-- CreateEnum
CREATE TYPE "PaymentScheduleStatus" AS ENUM ('DRAFT', 'ACTIVE', 'COMPLETE', 'OVERDUE', 'CANCELLED');

-- CreateEnum
CREATE TYPE "InstallmentStatus" AS ENUM ('PENDING', 'PAID', 'OVERDUE', 'CANCELLED');

-- CreateEnum
CREATE TYPE "OfflinePaymentMethod" AS ENUM ('BANK_TRANSFER', 'CASH', 'CHECK');

-- CreateEnum
CREATE TYPE "InvoiceType" AS ENUM ('DEPOSIT', 'BALANCE', 'CREDIT_NOTE');

-- CreateEnum
CREATE TYPE "InvoiceStatus" AS ENUM ('DRAFT', 'ISSUED', 'VOID');

-- CreateEnum
CREATE TYPE "PortalScope" AS ENUM ('VIEW_DOSSIER', 'SIGN_DOCUMENTS');

-- CreateEnum
CREATE TYPE "OutboxStatus" AS ENUM ('PENDING', 'PROCESSING', 'SENT', 'FAILED', 'DEAD');

-- CreateTable
CREATE TABLE "user" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "emailVerified" BOOLEAN NOT NULL DEFAULT false,
    "image" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "session" (
    "id" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "token" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "ipAddress" TEXT,
    "userAgent" TEXT,
    "userId" TEXT NOT NULL,

    CONSTRAINT "session_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "account" (
    "id" TEXT NOT NULL,
    "accountId" TEXT NOT NULL,
    "providerId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "accessToken" TEXT,
    "refreshToken" TEXT,
    "idToken" TEXT,
    "accessTokenExpiresAt" TIMESTAMP(3),
    "scope" TEXT,
    "password" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "account_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "verification" (
    "id" TEXT NOT NULL,
    "identifier" TEXT NOT NULL,
    "value" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "verification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tenant" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT,
    "logoUrl" TEXT,
    "legalName" TEXT,
    "vatMode" "VatMode" NOT NULL DEFAULT 'EXEMPT',
    "plan" "TenantPlan" NOT NULL DEFAULT 'TRIAL',
    "status" "TenantStatus" NOT NULL DEFAULT 'ACTIVE',
    "currency" TEXT NOT NULL DEFAULT 'EUR',
    "timeZone" TEXT NOT NULL DEFAULT 'Europe/Paris',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "tenant_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "membership" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "role" "MembershipRole" NOT NULL DEFAULT 'OWNER',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "membership_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "contact" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT NOT NULL,
    "firstName" TEXT,
    "lastName" TEXT,
    "email" TEXT,
    "phone" TEXT,
    "marketing_consent" BOOLEAN NOT NULL DEFAULT false,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "contact_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "lead" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT NOT NULL,
    "contact_id" TEXT,
    "source" TEXT,
    "stage" "LeadStage" NOT NULL DEFAULT 'NEW',
    "last_activity_at" TIMESTAMP(3),
    "lost_reason" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "lead_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "calendar_resource" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "calendar_resource_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "prestation" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT NOT NULL,
    "contact_id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "event_type" TEXT,
    "status" "PrestationStatus" NOT NULL DEFAULT 'DRAFT',
    "amount_cents" INTEGER NOT NULL DEFAULT 0,
    "currency" TEXT NOT NULL DEFAULT 'EUR',
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "prestation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "booking_slot" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT NOT NULL,
    "prestation_id" TEXT NOT NULL,
    "resource_id" TEXT NOT NULL,
    "starts_at" TIMESTAMPTZ(6) NOT NULL,
    "ends_at" TIMESTAMPTZ(6) NOT NULL,
    "status" "BookingStatus" NOT NULL DEFAULT 'OPTION',
    "location_name" TEXT,
    "location_address" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "booking_slot_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "option_hold" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT NOT NULL,
    "booking_slot_id" TEXT NOT NULL,
    "status" "OptionHoldStatus" NOT NULL DEFAULT 'ACTIVE',
    "expires_at" TIMESTAMPTZ(6) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "option_hold_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "catalog_item" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT NOT NULL,
    "label" TEXT NOT NULL,
    "description" TEXT,
    "unit" TEXT NOT NULL DEFAULT 'unit',
    "price_cents" INTEGER NOT NULL,
    "tax_rate_bps" INTEGER NOT NULL DEFAULT 0,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "catalog_item_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "quote" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT NOT NULL,
    "prestation_id" TEXT NOT NULL,
    "number" INTEGER NOT NULL,
    "version" INTEGER NOT NULL DEFAULT 1,
    "status" "QuoteStatus" NOT NULL DEFAULT 'DRAFT',
    "valid_until" TIMESTAMP(3),
    "subtotal_cents" INTEGER NOT NULL,
    "tax_cents" INTEGER NOT NULL,
    "total_cents" INTEGER NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'EUR',
    "sent_at" TIMESTAMP(3),
    "immutable_at" TIMESTAMP(3),
    "pdf_hash" TEXT,
    "storage_key" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "quote_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "quote_line" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT NOT NULL,
    "quote_id" TEXT NOT NULL,
    "label" TEXT NOT NULL,
    "description" TEXT,
    "quantity" DECIMAL(12,3) NOT NULL DEFAULT 1,
    "unit_price_cents" INTEGER NOT NULL,
    "tax_rate_bps" INTEGER NOT NULL DEFAULT 0,
    "total_cents" INTEGER NOT NULL,
    "position" INTEGER NOT NULL,

    CONSTRAINT "quote_line_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "contract" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT NOT NULL,
    "prestation_id" TEXT NOT NULL,
    "quote_id" TEXT NOT NULL,
    "status" "ContractStatus" NOT NULL DEFAULT 'DRAFT',
    "document_hash" TEXT,
    "storage_key" TEXT,
    "sent_at" TIMESTAMP(3),
    "signed_at" TIMESTAMP(3),
    "immutable_at" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "contract_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "signature_proof" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT NOT NULL,
    "contract_id" TEXT NOT NULL,
    "signer_email" TEXT NOT NULL,
    "ip_address" TEXT,
    "user_agent" TEXT,
    "document_hash" TEXT NOT NULL,
    "signed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "signature_proof_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payment_schedule" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT NOT NULL,
    "prestation_id" TEXT NOT NULL,
    "status" "PaymentScheduleStatus" NOT NULL DEFAULT 'DRAFT',
    "activated_at" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "payment_schedule_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payment_installment" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT NOT NULL,
    "schedule_id" TEXT NOT NULL,
    "sequence" INTEGER NOT NULL,
    "amount_cents" INTEGER NOT NULL,
    "due_at" TIMESTAMPTZ(6) NOT NULL,
    "status" "InstallmentStatus" NOT NULL DEFAULT 'PENDING',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "payment_installment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payment" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT NOT NULL,
    "prestation_id" TEXT NOT NULL,
    "installment_id" TEXT,
    "recorded_by_id" TEXT NOT NULL,
    "method" "OfflinePaymentMethod" NOT NULL,
    "amount_cents" INTEGER NOT NULL,
    "received_at" TIMESTAMPTZ(6) NOT NULL,
    "reference" TEXT,
    "receipt_key" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "payment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "invoice" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT NOT NULL,
    "prestation_id" TEXT NOT NULL,
    "number" INTEGER NOT NULL,
    "type" "InvoiceType" NOT NULL,
    "status" "InvoiceStatus" NOT NULL DEFAULT 'DRAFT',
    "subtotal_cents" INTEGER NOT NULL,
    "tax_cents" INTEGER NOT NULL,
    "total_cents" INTEGER NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'EUR',
    "issued_at" TIMESTAMP(3),
    "immutable_at" TIMESTAMP(3),
    "pdf_hash" TEXT,
    "storage_key" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "invoice_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "portal_token" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT NOT NULL,
    "prestation_id" TEXT NOT NULL,
    "token_hash" TEXT NOT NULL,
    "scope" "PortalScope" NOT NULL DEFAULT 'VIEW_DOSSIER',
    "expires_at" TIMESTAMPTZ(6) NOT NULL,
    "revoked_at" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "portal_token_pkey" PRIMARY KEY ("id")
);

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

-- CreateTable
CREATE TABLE "outbox_event" (
    "id" TEXT NOT NULL,
    "tenant_id" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "payload" JSONB NOT NULL,
    "status" "OutboxStatus" NOT NULL DEFAULT 'PENDING',
    "retry_count" INTEGER NOT NULL DEFAULT 0,
    "available_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "processed_at" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "outbox_event_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "user_email_key" ON "user"("email");

-- CreateIndex
CREATE INDEX "session_userId_idx" ON "session"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "session_token_key" ON "session"("token");

-- CreateIndex
CREATE INDEX "account_userId_idx" ON "account"("userId");

-- CreateIndex
CREATE INDEX "verification_identifier_idx" ON "verification"("identifier");

-- CreateIndex
CREATE INDEX "membership_user_id_idx" ON "membership"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "membership_tenant_id_user_id_key" ON "membership"("tenant_id", "user_id");

-- CreateIndex
CREATE INDEX "contact_tenant_id_email_idx" ON "contact"("tenant_id", "email");

-- CreateIndex
CREATE INDEX "contact_tenant_id_phone_idx" ON "contact"("tenant_id", "phone");

-- CreateIndex
CREATE INDEX "lead_tenant_id_stage_idx" ON "lead"("tenant_id", "stage");

-- CreateIndex
CREATE INDEX "lead_contact_id_idx" ON "lead"("contact_id");

-- CreateIndex
CREATE UNIQUE INDEX "calendar_resource_tenant_id_name_key" ON "calendar_resource"("tenant_id", "name");

-- CreateIndex
CREATE INDEX "prestation_tenant_id_status_idx" ON "prestation"("tenant_id", "status");

-- CreateIndex
CREATE INDEX "prestation_contact_id_idx" ON "prestation"("contact_id");

-- CreateIndex
CREATE INDEX "booking_slot_tenant_id_resource_id_starts_at_idx" ON "booking_slot"("tenant_id", "resource_id", "starts_at");

-- CreateIndex
CREATE INDEX "booking_slot_prestation_id_idx" ON "booking_slot"("prestation_id");

-- CreateIndex
CREATE UNIQUE INDEX "option_hold_booking_slot_id_key" ON "option_hold"("booking_slot_id");

-- CreateIndex
CREATE INDEX "option_hold_tenant_id_status_expires_at_idx" ON "option_hold"("tenant_id", "status", "expires_at");

-- CreateIndex
CREATE INDEX "catalog_item_tenant_id_active_idx" ON "catalog_item"("tenant_id", "active");

-- CreateIndex
CREATE INDEX "quote_prestation_id_idx" ON "quote"("prestation_id");

-- CreateIndex
CREATE UNIQUE INDEX "quote_tenant_id_number_version_key" ON "quote"("tenant_id", "number", "version");

-- CreateIndex
CREATE INDEX "quote_line_tenant_id_idx" ON "quote_line"("tenant_id");

-- CreateIndex
CREATE UNIQUE INDEX "quote_line_quote_id_position_key" ON "quote_line"("quote_id", "position");

-- CreateIndex
CREATE UNIQUE INDEX "contract_quote_id_key" ON "contract"("quote_id");

-- CreateIndex
CREATE INDEX "contract_tenant_id_status_idx" ON "contract"("tenant_id", "status");

-- CreateIndex
CREATE INDEX "signature_proof_tenant_id_signed_at_idx" ON "signature_proof"("tenant_id", "signed_at");

-- CreateIndex
CREATE INDEX "payment_schedule_tenant_id_status_idx" ON "payment_schedule"("tenant_id", "status");

-- CreateIndex
CREATE INDEX "payment_installment_tenant_id_status_due_at_idx" ON "payment_installment"("tenant_id", "status", "due_at");

-- CreateIndex
CREATE UNIQUE INDEX "payment_installment_schedule_id_sequence_key" ON "payment_installment"("schedule_id", "sequence");

-- CreateIndex
CREATE INDEX "payment_tenant_id_received_at_idx" ON "payment"("tenant_id", "received_at");

-- CreateIndex
CREATE INDEX "payment_installment_id_idx" ON "payment"("installment_id");

-- CreateIndex
CREATE INDEX "invoice_prestation_id_idx" ON "invoice"("prestation_id");

-- CreateIndex
CREATE UNIQUE INDEX "invoice_tenant_id_number_key" ON "invoice"("tenant_id", "number");

-- CreateIndex
CREATE UNIQUE INDEX "portal_token_token_hash_key" ON "portal_token"("token_hash");

-- CreateIndex
CREATE INDEX "portal_token_tenant_id_prestation_id_idx" ON "portal_token"("tenant_id", "prestation_id");

-- CreateIndex
CREATE INDEX "activity_log_tenant_id_createdAt_idx" ON "activity_log"("tenant_id", "createdAt");

-- CreateIndex
CREATE INDEX "activity_log_target_type_target_id_idx" ON "activity_log"("target_type", "target_id");

-- CreateIndex
CREATE INDEX "outbox_event_tenant_id_status_available_at_idx" ON "outbox_event"("tenant_id", "status", "available_at");

-- AddForeignKey
ALTER TABLE "session" ADD CONSTRAINT "session_userId_fkey" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "account" ADD CONSTRAINT "account_userId_fkey" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "membership" ADD CONSTRAINT "membership_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "membership" ADD CONSTRAINT "membership_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "contact" ADD CONSTRAINT "contact_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lead" ADD CONSTRAINT "lead_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lead" ADD CONSTRAINT "lead_contact_id_fkey" FOREIGN KEY ("contact_id") REFERENCES "contact"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "calendar_resource" ADD CONSTRAINT "calendar_resource_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "prestation" ADD CONSTRAINT "prestation_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "prestation" ADD CONSTRAINT "prestation_contact_id_fkey" FOREIGN KEY ("contact_id") REFERENCES "contact"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "booking_slot" ADD CONSTRAINT "booking_slot_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "booking_slot" ADD CONSTRAINT "booking_slot_prestation_id_fkey" FOREIGN KEY ("prestation_id") REFERENCES "prestation"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "booking_slot" ADD CONSTRAINT "booking_slot_resource_id_fkey" FOREIGN KEY ("resource_id") REFERENCES "calendar_resource"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "option_hold" ADD CONSTRAINT "option_hold_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "option_hold" ADD CONSTRAINT "option_hold_booking_slot_id_fkey" FOREIGN KEY ("booking_slot_id") REFERENCES "booking_slot"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "catalog_item" ADD CONSTRAINT "catalog_item_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "quote" ADD CONSTRAINT "quote_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "quote" ADD CONSTRAINT "quote_prestation_id_fkey" FOREIGN KEY ("prestation_id") REFERENCES "prestation"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "quote_line" ADD CONSTRAINT "quote_line_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "quote_line" ADD CONSTRAINT "quote_line_quote_id_fkey" FOREIGN KEY ("quote_id") REFERENCES "quote"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "contract" ADD CONSTRAINT "contract_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "contract" ADD CONSTRAINT "contract_prestation_id_fkey" FOREIGN KEY ("prestation_id") REFERENCES "prestation"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "contract" ADD CONSTRAINT "contract_quote_id_fkey" FOREIGN KEY ("quote_id") REFERENCES "quote"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "signature_proof" ADD CONSTRAINT "signature_proof_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "signature_proof" ADD CONSTRAINT "signature_proof_contract_id_fkey" FOREIGN KEY ("contract_id") REFERENCES "contract"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_schedule" ADD CONSTRAINT "payment_schedule_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_schedule" ADD CONSTRAINT "payment_schedule_prestation_id_fkey" FOREIGN KEY ("prestation_id") REFERENCES "prestation"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_installment" ADD CONSTRAINT "payment_installment_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_installment" ADD CONSTRAINT "payment_installment_schedule_id_fkey" FOREIGN KEY ("schedule_id") REFERENCES "payment_schedule"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment" ADD CONSTRAINT "payment_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment" ADD CONSTRAINT "payment_prestation_id_fkey" FOREIGN KEY ("prestation_id") REFERENCES "prestation"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment" ADD CONSTRAINT "payment_installment_id_fkey" FOREIGN KEY ("installment_id") REFERENCES "payment_installment"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment" ADD CONSTRAINT "payment_recorded_by_id_fkey" FOREIGN KEY ("recorded_by_id") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invoice" ADD CONSTRAINT "invoice_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invoice" ADD CONSTRAINT "invoice_prestation_id_fkey" FOREIGN KEY ("prestation_id") REFERENCES "prestation"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "portal_token" ADD CONSTRAINT "portal_token_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "portal_token" ADD CONSTRAINT "portal_token_prestation_id_fkey" FOREIGN KEY ("prestation_id") REFERENCES "prestation"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "activity_log" ADD CONSTRAINT "activity_log_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "activity_log" ADD CONSTRAINT "activity_log_actor_id_fkey" FOREIGN KEY ("actor_id") REFERENCES "user"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "outbox_event" ADD CONSTRAINT "outbox_event_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;
