/*
  Warnings:

  - Added the required column `business_type` to the `tenant` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "BusinessType" AS ENUM ('DECORATRICE', 'NEGAFA', 'WEDDING_PLANNER', 'PHOTO_VIDEO');

-- AlterTable
ALTER TABLE "tenant" ADD COLUMN     "business_type" "BusinessType" NOT NULL;
