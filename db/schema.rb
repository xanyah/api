# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_01_16_083151) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.string "name", null: false
    t.uuid "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", precision: nil, null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "category_id"
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.string "name"
    t.string "shopify_id"
    t.datetime "shopify_updated_at"
    t.uuid "store_id"
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_categories_on_category_id"
    t.index ["deleted_at"], name: "index_categories_on_deleted_at"
    t.index ["store_id"], name: "index_categories_on_store_id"
  end

  create_table "countries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_countries_on_code", unique: true
    t.index ["name"], name: "index_countries_on_name", unique: true
  end

  create_table "custom_attributes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.string "name"
    t.uuid "store_id"
    t.integer "type"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_custom_attributes_on_deleted_at"
    t.index ["store_id"], name: "index_custom_attributes_on_store_id"
  end

  create_table "customers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.string "email"
    t.string "firstname"
    t.string "lastname"
    t.text "notes"
    t.string "phone"
    t.uuid "store_id"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_customers_on_deleted_at"
    t.index ["store_id"], name: "index_customers_on_store_id"
  end

  create_table "file_imports", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "deleted_at", precision: nil
    t.boolean "processed", default: false
    t.uuid "store_id"
    t.datetime "updated_at", precision: nil, null: false
    t.uuid "user_id"
    t.index ["deleted_at"], name: "index_file_imports_on_deleted_at"
    t.index ["store_id"], name: "index_file_imports_on_store_id"
    t.index ["user_id"], name: "index_file_imports_on_user_id"
  end

  create_table "good_job_batches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "callback_priority"
    t.text "callback_queue_name"
    t.datetime "created_at", null: false
    t.text "description"
    t.datetime "discarded_at"
    t.datetime "enqueued_at"
    t.datetime "finished_at"
    t.datetime "jobs_finished_at"
    t.text "on_discard"
    t.text "on_finish"
    t.text "on_success"
    t.jsonb "serialized_properties"
    t.datetime "updated_at", null: false
  end

  create_table "good_job_executions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "active_job_id", null: false
    t.datetime "created_at", null: false
    t.interval "duration"
    t.text "error"
    t.text "error_backtrace", array: true
    t.integer "error_event", limit: 2
    t.datetime "finished_at"
    t.text "job_class"
    t.uuid "process_id"
    t.text "queue_name"
    t.datetime "scheduled_at"
    t.jsonb "serialized_params"
    t.datetime "updated_at", null: false
    t.index ["active_job_id", "created_at"], name: "index_good_job_executions_on_active_job_id_and_created_at"
    t.index ["process_id", "created_at"], name: "index_good_job_executions_on_process_id_and_created_at"
  end

  create_table "good_job_processes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "lock_type", limit: 2
    t.jsonb "state"
    t.datetime "updated_at", null: false
  end

  create_table "good_job_settings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "key"
    t.datetime "updated_at", null: false
    t.jsonb "value"
    t.index ["key"], name: "index_good_job_settings_on_key", unique: true
  end

  create_table "good_jobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "active_job_id"
    t.uuid "batch_callback_id"
    t.uuid "batch_id"
    t.text "concurrency_key"
    t.datetime "created_at", null: false
    t.datetime "cron_at"
    t.text "cron_key"
    t.text "error"
    t.integer "error_event", limit: 2
    t.integer "executions_count"
    t.datetime "finished_at"
    t.boolean "is_discrete"
    t.text "job_class"
    t.text "labels", array: true
    t.datetime "locked_at"
    t.uuid "locked_by_id"
    t.datetime "performed_at"
    t.integer "priority"
    t.text "queue_name"
    t.uuid "retried_good_job_id"
    t.datetime "scheduled_at"
    t.jsonb "serialized_params"
    t.datetime "updated_at", null: false
    t.index ["active_job_id", "created_at"], name: "index_good_jobs_on_active_job_id_and_created_at"
    t.index ["batch_callback_id"], name: "index_good_jobs_on_batch_callback_id", where: "(batch_callback_id IS NOT NULL)"
    t.index ["batch_id"], name: "index_good_jobs_on_batch_id", where: "(batch_id IS NOT NULL)"
    t.index ["concurrency_key", "created_at"], name: "index_good_jobs_on_concurrency_key_and_created_at"
    t.index ["concurrency_key"], name: "index_good_jobs_on_concurrency_key_when_unfinished", where: "(finished_at IS NULL)"
    t.index ["cron_key", "created_at"], name: "index_good_jobs_on_cron_key_and_created_at_cond", where: "(cron_key IS NOT NULL)"
    t.index ["cron_key", "cron_at"], name: "index_good_jobs_on_cron_key_and_cron_at_cond", unique: true, where: "(cron_key IS NOT NULL)"
    t.index ["finished_at"], name: "index_good_jobs_jobs_on_finished_at", where: "((retried_good_job_id IS NULL) AND (finished_at IS NOT NULL))"
    t.index ["job_class"], name: "index_good_jobs_on_job_class"
    t.index ["labels"], name: "index_good_jobs_on_labels", where: "(labels IS NOT NULL)", using: :gin
    t.index ["locked_by_id"], name: "index_good_jobs_on_locked_by_id", where: "(locked_by_id IS NOT NULL)"
    t.index ["priority", "created_at"], name: "index_good_job_jobs_for_candidate_lookup", where: "(finished_at IS NULL)"
    t.index ["priority", "created_at"], name: "index_good_jobs_jobs_on_priority_created_at_when_unfinished", order: { priority: "DESC NULLS LAST" }, where: "(finished_at IS NULL)"
    t.index ["priority", "scheduled_at"], name: "index_good_jobs_on_priority_scheduled_at_unfinished_unlocked", where: "((finished_at IS NULL) AND (locked_by_id IS NULL))"
    t.index ["queue_name", "scheduled_at"], name: "index_good_jobs_on_queue_name_and_scheduled_at", where: "(finished_at IS NULL)"
    t.index ["scheduled_at"], name: "index_good_jobs_on_scheduled_at", where: "(finished_at IS NULL)"
  end

  create_table "inventories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.datetime "locked_at"
    t.integer "progress", default: 0
    t.string "status", default: "pending"
    t.datetime "stock_update_ended_at"
    t.datetime "stock_update_started_at"
    t.uuid "store_id"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_inventories_on_deleted_at"
    t.index ["store_id"], name: "index_inventories_on_store_id"
  end

  create_table "inventory_products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.uuid "inventory_id", null: false
    t.uuid "product_id", null: false
    t.integer "quantity", default: 1
    t.datetime "updated_at", null: false
    t.index ["inventory_id"], name: "index_inventory_products_on_inventory_id"
    t.index ["product_id"], name: "index_inventory_products_on_product_id"
  end

  create_table "manufacturers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.string "name"
    t.string "notes"
    t.string "shopify_id"
    t.datetime "shopify_updated_at"
    t.uuid "store_id"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_manufacturers_on_deleted_at"
    t.index ["store_id"], name: "index_manufacturers_on_store_id"
  end

  create_table "oauth_access_grants", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "application_id", null: false
    t.datetime "created_at", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.uuid "resource_owner_id", null: false
    t.datetime "revoked_at"
    t.string "scopes", default: "", null: false
    t.string "token", null: false
    t.index ["application_id"], name: "index_oauth_access_grants_on_application_id"
    t.index ["resource_owner_id"], name: "index_oauth_access_grants_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.uuid "application_id"
    t.datetime "created_at", null: false
    t.integer "expires_in"
    t.string "previous_refresh_token", default: "", null: false
    t.string "refresh_token"
    t.uuid "resource_owner_id"
    t.datetime "revoked_at"
    t.string "scopes"
    t.string "token", null: false
    t.index ["application_id"], name: "index_oauth_access_tokens_on_application_id"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "confidential", default: true, null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.text "redirect_uri"
    t.string "scopes", default: "", null: false
    t.string "secret", null: false
    t.string "uid", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "order_products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.uuid "order_id", null: false
    t.uuid "product_id", null: false
    t.integer "quantity", default: 1
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_products_on_order_id"
    t.index ["product_id"], name: "index_order_products_on_product_id"
  end

  create_table "orders", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "cancelled_at"
    t.datetime "created_at", null: false
    t.uuid "customer_id"
    t.datetime "deleted_at", precision: nil
    t.datetime "delivered_at"
    t.datetime "ordered_at"
    t.string "state"
    t.uuid "store_id"
    t.datetime "updated_at", null: false
    t.datetime "withdrawn_at"
    t.index ["customer_id"], name: "index_orders_on_customer_id"
    t.index ["deleted_at"], name: "index_orders_on_deleted_at"
    t.index ["store_id"], name: "index_orders_on_store_id"
  end

  create_table "payment_types", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.text "description"
    t.string "name"
    t.uuid "store_id"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_payment_types_on_deleted_at"
    t.index ["store_id"], name: "index_payment_types_on_store_id"
  end

  create_table "product_custom_attributes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.uuid "custom_attribute_id", null: false
    t.datetime "deleted_at"
    t.uuid "product_id", null: false
    t.datetime "updated_at", null: false
    t.string "value"
    t.index ["custom_attribute_id"], name: "index_product_custom_attributes_on_custom_attribute_id"
    t.index ["product_id"], name: "index_product_custom_attributes_on_product_id"
  end

  create_table "products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "EUR", null: false
    t.datetime "archived_at"
    t.integer "buying_amount_cents", default: 0, null: false
    t.string "buying_amount_currency", default: "EUR", null: false
    t.uuid "category_id"
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.text "description"
    t.uuid "manufacturer_id"
    t.string "manufacturer_sku"
    t.string "name"
    t.integer "quantity", default: 0
    t.string "shopify_product_id"
    t.datetime "shopify_updated_at"
    t.string "shopify_variant_inventory_item_id"
    t.string "sku"
    t.uuid "store_id"
    t.integer "tax_free_amount_cents", default: 0, null: false
    t.string "tax_free_amount_currency", default: "EUR", null: false
    t.string "upc"
    t.datetime "updated_at", null: false
    t.uuid "vat_rate_id"
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["deleted_at"], name: "index_products_on_deleted_at"
    t.index ["manufacturer_id"], name: "index_products_on_manufacturer_id"
    t.index ["store_id"], name: "index_products_on_store_id"
    t.index ["vat_rate_id"], name: "index_products_on_vat_rate_id"
  end

  create_table "providers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.string "name"
    t.string "notes"
    t.uuid "store_id"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_providers_on_deleted_at"
    t.index ["store_id"], name: "index_providers_on_store_id"
  end

  create_table "sale_payments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.uuid "payment_type_id"
    t.uuid "sale_id"
    t.integer "total_amount_cents", default: 0, null: false
    t.string "total_amount_currency", default: "EUR", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_sale_payments_on_deleted_at"
    t.index ["payment_type_id"], name: "index_sale_payments_on_payment_type_id"
    t.index ["sale_id"], name: "index_sale_payments_on_sale_id"
  end

  create_table "sale_products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "EUR", null: false
    t.datetime "created_at", null: false
    t.string "custom_label"
    t.datetime "deleted_at"
    t.integer "original_amount_cents", default: 0, null: false
    t.string "original_amount_currency", default: "EUR", null: false
    t.uuid "product_id"
    t.integer "quantity", default: 1
    t.uuid "sale_id", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_sale_products_on_product_id"
    t.index ["sale_id"], name: "index_sale_products_on_sale_id"
  end

  create_table "sale_promotions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "EUR", null: false
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.uuid "sale_id"
    t.integer "type"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_sale_promotions_on_deleted_at"
    t.index ["sale_id"], name: "index_sale_promotions_on_sale_id"
  end

  create_table "sales", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "completed", default: false
    t.datetime "created_at", null: false
    t.uuid "customer_id"
    t.datetime "deleted_at", precision: nil
    t.uuid "store_id"
    t.integer "total_amount_cents", default: 0, null: false
    t.string "total_amount_currency", default: "EUR", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id"
    t.index ["customer_id"], name: "index_sales_on_customer_id"
    t.index ["deleted_at"], name: "index_sales_on_deleted_at"
    t.index ["store_id"], name: "index_sales_on_store_id"
    t.index ["user_id"], name: "index_sales_on_user_id"
  end

  create_table "shipping_products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.uuid "product_id", null: false
    t.integer "quantity", default: 1
    t.uuid "shipping_id", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_shipping_products_on_product_id"
    t.index ["shipping_id"], name: "index_shipping_products_on_shipping_id"
  end

  create_table "shippings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "cancelled_at"
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.uuid "provider_id"
    t.string "state"
    t.uuid "store_id"
    t.datetime "updated_at", null: false
    t.datetime "validated_at"
    t.index ["deleted_at"], name: "index_shippings_on_deleted_at"
    t.index ["provider_id"], name: "index_shippings_on_provider_id"
    t.index ["store_id"], name: "index_shippings_on_store_id"
  end

  create_table "store_memberships", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.integer "role"
    t.uuid "store_id"
    t.datetime "updated_at", null: false
    t.uuid "user_id"
    t.index ["deleted_at"], name: "index_store_memberships_on_deleted_at"
    t.index ["store_id"], name: "index_store_memberships_on_store_id"
    t.index ["user_id"], name: "index_store_memberships_on_user_id"
  end

  create_table "stores", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "address1"
    t.string "address2"
    t.text "ai_prompt"
    t.string "city"
    t.string "color"
    t.uuid "country_id"
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.string "email_address"
    t.boolean "is_import_enabled", default: false
    t.string "key"
    t.string "name"
    t.string "openai_api_key"
    t.string "phone_number"
    t.string "shopify_access_token"
    t.string "shopify_location_id"
    t.string "shopify_shop"
    t.datetime "shopify_updated_at"
    t.datetime "updated_at", null: false
    t.string "website_url"
    t.string "zipcode"
    t.index ["country_id"], name: "index_stores_on_country_id"
    t.index ["deleted_at"], name: "index_stores_on_deleted_at"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "confirmation_sent_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.datetime "deleted_at", precision: nil
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.integer "failed_attempts", default: 0, null: false
    t.string "firstname"
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.string "lastname"
    t.string "locale", default: "en"
    t.datetime "locked_at"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "sign_in_count", default: 0, null: false
    t.json "tokens"
    t.string "unconfirmed_email"
    t.string "unlock_token"
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vat_rates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "country_id"
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.integer "rate_percent_cents"
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_vat_rates_on_country_id"
  end

  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "categories", "categories"
  add_foreign_key "categories", "stores"
  add_foreign_key "custom_attributes", "stores"
  add_foreign_key "customers", "stores"
  add_foreign_key "file_imports", "stores"
  add_foreign_key "file_imports", "users"
  add_foreign_key "inventories", "stores"
  add_foreign_key "inventory_products", "inventories"
  add_foreign_key "inventory_products", "products"
  add_foreign_key "manufacturers", "stores"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_grants", "users", column: "resource_owner_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "users", column: "resource_owner_id"
  add_foreign_key "order_products", "orders"
  add_foreign_key "order_products", "products"
  add_foreign_key "orders", "customers"
  add_foreign_key "orders", "stores"
  add_foreign_key "payment_types", "stores"
  add_foreign_key "product_custom_attributes", "custom_attributes"
  add_foreign_key "product_custom_attributes", "products"
  add_foreign_key "products", "categories"
  add_foreign_key "products", "manufacturers"
  add_foreign_key "products", "stores"
  add_foreign_key "providers", "stores"
  add_foreign_key "sale_payments", "payment_types"
  add_foreign_key "sale_payments", "sales"
  add_foreign_key "sale_products", "products"
  add_foreign_key "sale_products", "sales"
  add_foreign_key "sale_promotions", "sales"
  add_foreign_key "sales", "customers"
  add_foreign_key "sales", "stores"
  add_foreign_key "sales", "users"
  add_foreign_key "shipping_products", "products"
  add_foreign_key "shipping_products", "shippings"
  add_foreign_key "shippings", "stores"
  add_foreign_key "store_memberships", "stores"
  add_foreign_key "store_memberships", "users"
end
