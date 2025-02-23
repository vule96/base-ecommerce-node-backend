-- CreateEnum
CREATE TYPE "user_status" AS ENUM ('active', 'inactive', 'banned', 'pending');

-- CreateEnum
CREATE TYPE "product_status" AS ENUM ('draft', 'active', 'inactive', 'archived');

-- CreateEnum
CREATE TYPE "category_status" AS ENUM ('active', 'inactive');

-- CreateEnum
CREATE TYPE "user_role" AS ENUM ('user', 'admin');

-- CreateTable
CREATE TABLE "user" (
    "id" UUID NOT NULL,
    "avatar" VARCHAR(255),
    "email" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "is_email_verified" BOOLEAN NOT NULL DEFAULT false,
    "first_name" VARCHAR(100) NOT NULL,
    "last_name" VARCHAR(100) NOT NULL,
    "password" VARCHAR(100) NOT NULL,
    "phone" VARCHAR(20) NOT NULL,
    "salt" VARCHAR(50) NOT NULL,
    "status" "user_status" DEFAULT 'active',
    "role" "user_role" NOT NULL DEFAULT 'user',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "user_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "token" (
    "id" UUID NOT NULL,
    "token" TEXT NOT NULL,
    "expires_at" TIMESTAMPTZ NOT NULL,
    "is_blacklisted" BOOLEAN NOT NULL DEFAULT false,
    "ip_address" VARCHAR(45),
    "user_agent" VARCHAR(100),
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "user_id" UUID NOT NULL,

    CONSTRAINT "token_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "product" (
    "id" UUID NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "slug" VARCHAR(100) NOT NULL,
    "description" TEXT NOT NULL,
    "short_description" VARCHAR(100) NOT NULL,
    "stock" INTEGER NOT NULL DEFAULT 0,
    "status" "product_status" DEFAULT 'active',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "category_id" UUID,

    CONSTRAINT "product_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "category" (
    "id" UUID NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "slug" VARCHAR(100) NOT NULL,
    "parent_id" UUID,
    "status" "category_status" DEFAULT 'active',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "category_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "attribute" (
    "id" UUID NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "attribute_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "attribute_value" (
    "id" UUID NOT NULL,
    "value" VARCHAR(100) NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "attribute_id" UUID NOT NULL,

    CONSTRAINT "attribute_value_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "product_attribute" (
    "id" UUID NOT NULL,
    "product_id" UUID NOT NULL,
    "attribute_id" UUID NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "product_attribute_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "product_attribute_value" (
    "id" UUID NOT NULL,
    "product_attribute_id" UUID NOT NULL,
    "attribute_value_id" UUID NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "product_attribute_value_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "user_email_key" ON "user"("email");

-- CreateIndex
CREATE UNIQUE INDEX "user_username_key" ON "user"("username");

-- CreateIndex
CREATE INDEX "idx_user_status" ON "user"("status");

-- CreateIndex
CREATE INDEX "idx_user_role" ON "user"("role");

-- CreateIndex
CREATE INDEX "idx_token_user_id" ON "token"("user_id");

-- CreateIndex
CREATE INDEX "idx_blacklisted" ON "token"("is_blacklisted");

-- CreateIndex
CREATE UNIQUE INDEX "product_name_key" ON "product"("name");

-- CreateIndex
CREATE UNIQUE INDEX "product_slug_key" ON "product"("slug");

-- CreateIndex
CREATE INDEX "idx_product_status" ON "product"("status");

-- CreateIndex
CREATE UNIQUE INDEX "category_name_key" ON "category"("name");

-- CreateIndex
CREATE UNIQUE INDEX "category_slug_key" ON "category"("slug");

-- CreateIndex
CREATE INDEX "idx_category_parent_id" ON "category"("parent_id");

-- CreateIndex
CREATE UNIQUE INDEX "attribute_name_key" ON "attribute"("name");

-- CreateIndex
CREATE INDEX "idx_attribute_value_attribute_id" ON "attribute_value"("attribute_id");

-- CreateIndex
CREATE INDEX "idx_product_attribute_product_attribute" ON "product_attribute"("product_id", "attribute_id");

-- CreateIndex
CREATE INDEX "idx_product_attribute_value_product_attribute_id" ON "product_attribute_value"("product_attribute_id");

-- CreateIndex
CREATE INDEX "idx_product_attribute_value_attribute_value_id" ON "product_attribute_value"("attribute_value_id");

-- AddForeignKey
ALTER TABLE "token" ADD CONSTRAINT "token_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product" ADD CONSTRAINT "product_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "category"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "category" ADD CONSTRAINT "category_parent_id_fkey" FOREIGN KEY ("parent_id") REFERENCES "category"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attribute_value" ADD CONSTRAINT "attribute_value_attribute_id_fkey" FOREIGN KEY ("attribute_id") REFERENCES "attribute"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product_attribute" ADD CONSTRAINT "product_attribute_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product_attribute" ADD CONSTRAINT "product_attribute_attribute_id_fkey" FOREIGN KEY ("attribute_id") REFERENCES "attribute"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product_attribute_value" ADD CONSTRAINT "product_attribute_value_product_attribute_id_fkey" FOREIGN KEY ("product_attribute_id") REFERENCES "product_attribute"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product_attribute_value" ADD CONSTRAINT "product_attribute_value_attribute_value_id_fkey" FOREIGN KEY ("attribute_value_id") REFERENCES "attribute_value"("id") ON DELETE CASCADE ON UPDATE CASCADE;
