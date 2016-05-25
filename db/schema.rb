# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160525173446) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string   "name"
    t.string   "full_domain"
    t.datetime "deleted_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "domain"
  end

  add_index "accounts", ["deleted_at"], name: "index_accounts_on_deleted_at", using: :btree

  create_table "addresses", force: :cascade do |t|
    t.string   "street"
    t.string   "street2"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.string   "label"
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.datetime "deleted_at"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "addresses", ["deleted_at"], name: "index_addresses_on_deleted_at", using: :btree

  create_table "auth_tokens", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "authentication_token"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "auth_tokens", ["authentication_token"], name: "index_auth_tokens_on_authentication_token", unique: true, using: :btree
  add_index "auth_tokens", ["user_id"], name: "index_auth_tokens_on_user_id", using: :btree

  create_table "clinic_preferences", force: :cascade do |t|
    t.integer  "clinic_id"
    t.string   "internal_account_uid_scheme"
    t.string   "additional_transaction_number"
    t.string   "patient_number_scheme"
    t.string   "transaction_number_scheme"
    t.integer  "overdue_fee_percentage"
    t.string   "should_use_clinic_name"
    t.boolean  "should_print_diagnosis_description_on_hcfa", default: false
    t.boolean  "should_send_statements_when_overdue",        default: false
    t.boolean  "should_charge_overdue_account",              default: false
    t.string   "insurance_carrier_assignment_policy"
    t.boolean  "should_show_clinic_on_letter",               default: false
    t.boolean  "should_show_clinic_on_bill",                 default: false
    t.string   "workmanscomp_boilerplate"
    t.string   "patient_current_statement_message"
    t.string   "patient_30days_statement_message"
    t.string   "patient_60days_statement_message"
    t.string   "patient_90days_statement_message"
    t.string   "patient_120days_statement_message"
    t.boolean  "should_print_clinic_address_on_envelope",    default: false
    t.integer  "payment_display_code"
    t.datetime "deleted_at"
    t.integer  "should_split_bills_by_provider"
    t.integer  "default_place_of_service"
    t.string   "box_32_use"
    t.string   "box_33_use"
    t.string   "letter_use"
    t.string   "statement_use"
    t.float    "hcfa_left_margin"
    t.float    "hcfa_top_margin"
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
  end

  add_index "clinic_preferences", ["deleted_at"], name: "index_clinic_preferences_on_deleted_at", using: :btree

  create_table "clinics", force: :cascade do |t|
    t.integer  "contact_id"
    t.integer  "address_id"
    t.integer  "billing_address_id"
    t.string   "tax_uuid"
    t.string   "type_ii_npi_uuid"
    t.string   "main_provider_id"
    t.integer  "account_id"
    t.boolean  "same_as_service_location"
    t.datetime "deleted_at"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "slug"
  end

  add_index "clinics", ["deleted_at"], name: "index_clinics_on_deleted_at", using: :btree
  add_index "clinics", ["slug"], name: "index_clinics_on_slug", using: :btree

  create_table "contacts", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "company_name"
    t.string   "phone1_ext"
    t.string   "phone1"
    t.string   "phone2_ext"
    t.string   "phone2"
    t.string   "phone3_ext"
    t.string   "phone3"
    t.string   "email1"
    t.string   "email2"
    t.string   "attention"
    t.text     "notes"
    t.string   "title"
    t.string   "fax1"
    t.string   "sex"
    t.string   "occupation"
    t.string   "middle_initial"
    t.datetime "deleted_at"
    t.integer  "contactable_id"
    t.string   "contactable_type"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "slug"
  end

  add_index "contacts", ["deleted_at"], name: "index_contacts_on_deleted_at", using: :btree
  add_index "contacts", ["slug"], name: "index_contacts_on_slug", using: :btree

  create_table "legacy_id_labels", force: :cascade do |t|
    t.string   "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "patients", force: :cascade do |t|
    t.integer  "clinic_id"
    t.string   "encrypted_ssn"
    t.date     "birthdate"
    t.string   "slug"
    t.string   "spouse_name"
    t.integer  "referrer_id"
    t.boolean  "is_active",                           default: true
    t.string   "statement_message"
    t.datetime "deleted_at"
    t.string   "address_stationery_to_label"
    t.boolean  "is_full_time_student",                default: false
    t.integer  "marital_status_code"
    t.integer  "disability_status_code"
    t.boolean  "should_send_statements_when_overdue", default: true
    t.integer  "overdue_fee_percentage"
    t.text     "notes"
    t.integer  "contact_id"
    t.integer  "address_id"
    t.string   "referrer_type"
    t.integer  "employer_contact_id"
    t.integer  "employer_address_id"
    t.string   "account_code"
    t.integer  "employment_status_code"
    t.string   "category"
    t.integer  "parent_patient_id"
    t.integer  "import_id"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
  end

  add_index "patients", ["address_id"], name: "index_patients_on_address_id", using: :btree
  add_index "patients", ["clinic_id"], name: "index_patients_on_clinic_id", using: :btree
  add_index "patients", ["contact_id"], name: "index_patients_on_contact_id", using: :btree
  add_index "patients", ["deleted_at"], name: "index_patients_on_deleted_at", using: :btree
  add_index "patients", ["referrer_id"], name: "index_patients_on_referrer_id", using: :btree
  add_index "patients", ["slug"], name: "index_patients_on_slug", using: :btree

  create_table "plan_facilities", force: :cascade do |t|
    t.string   "name"
    t.integer  "plan_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "plan_facilities", ["plan_id"], name: "index_plan_facilities_on_plan_id", using: :btree

  create_table "plans", force: :cascade do |t|
    t.string   "name"
    t.integer  "price",      default: 0
    t.string   "title"
    t.integer  "clinic",     default: 0
    t.integer  "doctor",     default: 0
    t.boolean  "primary",    default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "providers", force: :cascade do |t|
    t.integer  "clinic_id"
    t.string   "signature_name"
    t.string   "provider_type_code"
    t.string   "tax_uid"
    t.string   "upin_uid"
    t.string   "license"
    t.text     "notes"
    t.string   "nycomp_testify"
    t.string   "npi_uid"
    t.integer  "contact_id"
    t.integer  "address_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.datetime "deleted_at"
    t.string   "slug"
    t.integer  "account_id"
  end

  add_index "providers", ["address_id"], name: "index_providers_on_address_id", using: :btree
  add_index "providers", ["clinic_id"], name: "index_providers_on_clinic_id", using: :btree
  add_index "providers", ["contact_id"], name: "index_providers_on_contact_id", using: :btree
  add_index "providers", ["deleted_at"], name: "index_providers_on_deleted_at", using: :btree
  add_index "providers", ["slug"], name: "index_providers_on_slug", using: :btree

  create_table "providers_legacy_id_labels", force: :cascade do |t|
    t.integer  "legacy_id_label_id"
    t.integer  "provider_id"
    t.string   "legacy_id_value"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "providers_legacy_id_labels", ["legacy_id_label_id"], name: "index_providers_legacy_id_labels_on_legacy_id_label_id", using: :btree
  add_index "providers_legacy_id_labels", ["provider_id"], name: "index_providers_legacy_id_labels_on_provider_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "username"
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
    t.boolean  "admin",                  default: false
    t.boolean  "system_admin"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

end
