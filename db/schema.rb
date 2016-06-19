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

ActiveRecord::Schema.define(version: 20160619121322) do

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

  create_table "attorneys", force: :cascade do |t|
    t.integer  "address_id"
    t.integer  "contact_id"
    t.datetime "deleted_at"
    t.integer  "insurance_carrier_id"
    t.text     "notes"
    t.integer  "account_id"
    t.string   "slug"
    t.string   "attorney_name"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "attorneys", ["account_id"], name: "index_attorneys_on_account_id", using: :btree
  add_index "attorneys", ["address_id"], name: "index_attorneys_on_address_id", using: :btree
  add_index "attorneys", ["contact_id"], name: "index_attorneys_on_contact_id", using: :btree
  add_index "attorneys", ["insurance_carrier_id"], name: "index_attorneys_on_insurance_carrier_id", using: :btree
  add_index "attorneys", ["slug"], name: "index_attorneys_on_slug", using: :btree

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

  create_table "diagnosis_codes", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.text     "description"
    t.datetime "deleted_at"
    t.integer  "clinic_id"
    t.integer  "account_id"
    t.string   "slug"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "diagnosis_codes", ["account_id"], name: "index_diagnosis_codes_on_account_id", using: :btree
  add_index "diagnosis_codes", ["clinic_id"], name: "index_diagnosis_codes_on_clinic_id", using: :btree
  add_index "diagnosis_codes", ["slug"], name: "index_diagnosis_codes_on_slug", using: :btree

  create_table "fee_schedule_labels", force: :cascade do |t|
    t.string   "label"
    t.integer  "clinic_id"
    t.integer  "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "fee_schedule_labels", ["account_id"], name: "index_fee_schedule_labels_on_account_id", using: :btree
  add_index "fee_schedule_labels", ["clinic_id"], name: "index_fee_schedule_labels_on_clinic_id", using: :btree

  create_table "insurance_carriers", force: :cascade do |t|
    t.integer  "contact_id"
    t.integer  "insurance_carrier_type_code"
    t.integer  "insurance_type_code"
    t.string   "payer_code"
    t.string   "claims_office_sub_code"
    t.string   "clinic_code"
    t.string   "medigap_code"
    t.string   "alias_name"
    t.integer  "address_id"
    t.datetime "deleted_at"
    t.string   "name"
    t.text     "notes"
    t.integer  "legacy_id_label_id"
    t.integer  "import_id"
    t.integer  "account_id"
    t.string   "slug"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "insurance_carriers", ["account_id"], name: "index_insurance_carriers_on_account_id", using: :btree
  add_index "insurance_carriers", ["address_id"], name: "index_insurance_carriers_on_address_id", using: :btree
  add_index "insurance_carriers", ["contact_id"], name: "index_insurance_carriers_on_contact_id", using: :btree
  add_index "insurance_carriers", ["slug"], name: "index_insurance_carriers_on_slug", using: :btree

  create_table "legacy_id_labels", force: :cascade do |t|
    t.string   "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "letters", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.text     "body"
    t.string   "salutation"
    t.datetime "deleted_at"
    t.boolean  "should_sign_clinic_name"
    t.integer  "account_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "letters", ["account_id"], name: "index_letters_on_account_id", using: :btree
  add_index "letters", ["slug"], name: "index_letters_on_slug", using: :btree

  create_table "patient_bills", force: :cascade do |t|
    t.integer  "patient_case_id"
    t.integer  "insurance_carrier_id"
    t.integer  "provider_id"
    t.boolean  "is_secondary_claim",            default: false
    t.integer  "status_code"
    t.boolean  "is_workmanscomp_progress_form", default: false
    t.boolean  "is_assigned"
    t.datetime "hcfa_bill_date"
    t.datetime "deleted_at"
    t.text     "notes"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  add_index "patient_bills", ["deleted_at"], name: "index_patient_bills_on_deleted_at", using: :btree
  add_index "patient_bills", ["insurance_carrier_id"], name: "index_patient_bills_on_insurance_carrier_id", using: :btree
  add_index "patient_bills", ["patient_case_id"], name: "index_patient_bills_on_patient_case_id", using: :btree
  add_index "patient_bills", ["provider_id"], name: "index_patient_bills_on_provider_id", using: :btree

  create_table "patient_cases", force: :cascade do |t|
    t.string   "slug"
    t.integer  "patient_id"
    t.integer  "provider_id"
    t.string   "description"
    t.integer  "referrer_id"
    t.integer  "attorney_id"
    t.integer  "primary_insurance_carrier_id"
    t.integer  "secondary_insurance_carrier_id"
    t.integer  "primary_guarantor_contact_id"
    t.integer  "secondary_guarantor_contact_id"
    t.string   "primary_insurance_carrier_group_uid"
    t.string   "secondary_insurance_carrier_group_uid"
    t.string   "primary_insurance_carrier_policy_uid"
    t.string   "secondary_insurance_carrier_policy_uid"
    t.string   "hcfa_1a_primary"
    t.string   "hcfa_1a_secondary"
    t.string   "relationship_to_primary_guarantor"
    t.string   "relationship_to_secondary_guarantor"
    t.boolean  "primary_insurance_carrier_assignment",       default: false
    t.boolean  "secondary_insurance_carrier_assignment",     default: false
    t.boolean  "should_hold_primary_bill"
    t.boolean  "should_hold_secondary_bill"
    t.integer  "primary_max_pay_per_visit_cents"
    t.integer  "secondary_max_pay_per_visit_cents"
    t.integer  "primary_max_pay_per_year_cents"
    t.integer  "secondary_max_pay_per_year_cents"
    t.integer  "primary_max_visits_per_year"
    t.integer  "secondary_max_visits_per_year"
    t.integer  "primary_max_pay_per_life_cents"
    t.integer  "secondary_max_pay_per_life_cents"
    t.integer  "primary_max_visits_per_life"
    t.integer  "secondary_max_visits_per_life"
    t.integer  "primary_deductible_cents",                   default: 0
    t.integer  "secondary_deductible_cents",                 default: 0
    t.integer  "primary_paid_cents",                         default: 0
    t.integer  "secondary_paid_cents",                       default: 0
    t.date     "hcfa_similar_symptoms_date"
    t.boolean  "hcfa_had_lab_work",                          default: false
    t.boolean  "hcfa_is_employment_related",                 default: false
    t.boolean  "hcfa_is_auto_accident",                      default: false
    t.boolean  "hcfa_is_non_auto_accident",                  default: false
    t.string   "hcfa_prior_authorization"
    t.string   "hcfa_medicaid_resubmission"
    t.string   "hcfa_original_ref"
    t.boolean  "is_emergency",                               default: false
    t.boolean  "nys_workmanscomp_is_initial_or_final",       default: false
    t.integer  "disability_percentage"
    t.integer  "disability_status_code"
    t.date     "exacerbation_date"
    t.date     "xray_date"
    t.date     "workmanscomp_return_to_work_date"
    t.date     "workmanscomp_start_disability_date"
    t.date     "workmanscomp_end_disability_date"
    t.date     "workmanscomp_start_partial_disability_date"
    t.date     "workmanscomp_end_partial_disability_date"
    t.datetime "releases_from_care_date"
    t.datetime "accident_time"
    t.date     "accident_date"
    t.string   "accident_state"
    t.string   "accident_city"
    t.string   "workmanscomp_uid"
    t.string   "accident_description"
    t.integer  "diagnosis1_id"
    t.string   "diagnosis1_description",                     default: ":"
    t.integer  "diagnosis2_id"
    t.string   "diagnosis2_description",                     default: ":"
    t.integer  "diagnosis3_id"
    t.string   "diagnosis3_description",                     default: ":"
    t.integer  "diagnosis4_id"
    t.string   "diagnosis4_description",                     default: ":"
    t.string   "treatment_phase"
    t.string   "exacerbation_or_reoccurence"
    t.string   "subx_level"
    t.string   "hcfa_10d"
    t.boolean  "is_xray_available",                          default: false
    t.boolean  "medicare_abn_waiver_signed",                 default: false
    t.boolean  "is_billable",                                default: false
    t.text     "notes"
    t.boolean  "is_active",                                  default: false
    t.date     "primary_authorization_through_date"
    t.date     "secondary_authorization_through_date"
    t.datetime "deleted_at"
    t.string   "hcfa_accident_state"
    t.string   "c4_accident_city"
    t.string   "hcfa_box19_accident_description"
    t.datetime "released_from_care_date"
    t.string   "referrer_type"
    t.integer  "fee_schedule_label_id"
    t.date     "onset_at"
    t.date     "first_treated_at"
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
  end

  add_index "patient_cases", ["attorney_id"], name: "index_patient_cases_on_attorney_id", using: :btree
  add_index "patient_cases", ["patient_id"], name: "index_patient_cases_on_patient_id", using: :btree
  add_index "patient_cases", ["provider_id"], name: "index_patient_cases_on_provider_id", using: :btree
  add_index "patient_cases", ["referrer_id"], name: "index_patient_cases_on_referrer_id", using: :btree

  create_table "patient_visit_details", force: :cascade do |t|
    t.integer  "patient_case_id"
    t.integer  "patient_visit_id"
    t.integer  "provider_id"
    t.integer  "procedure_code_id"
    t.integer  "amount_cents"
    t.integer  "patient_owes_cent"
    t.integer  "insurance_owes_cents"
    t.integer  "units_sold"
    t.string   "diagnosis_pointer"
    t.integer  "place_of_service_code"
    t.datetime "deleted_at"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "patient_visit_details", ["deleted_at"], name: "index_patient_visit_details_on_deleted_at", using: :btree
  add_index "patient_visit_details", ["patient_case_id"], name: "index_patient_visit_details_on_patient_case_id", using: :btree
  add_index "patient_visit_details", ["patient_visit_id"], name: "index_patient_visit_details_on_patient_visit_id", using: :btree
  add_index "patient_visit_details", ["procedure_code_id"], name: "index_patient_visit_details_on_procedure_code_id", using: :btree
  add_index "patient_visit_details", ["provider_id"], name: "index_patient_visit_details_on_provider_id", using: :btree

  create_table "patient_visit_payments", force: :cascade do |t|
    t.integer  "source_patient_visit_detail_id"
    t.integer  "destination_patient_visit_detail_id"
    t.integer  "amount_cents"
    t.integer  "transfer_direction_code"
    t.datetime "deleted_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "patient_visits", force: :cascade do |t|
    t.integer  "patient_case_id"
    t.datetime "visited_at"
    t.string   "fee_slip_number"
    t.boolean  "should_bill_primary",       default: false
    t.integer  "primary_patient_bill_id"
    t.boolean  "should_bill_secondary",     default: false
    t.integer  "secondary_patient_bill_id"
    t.boolean  "should_bill_attorney",      default: false
    t.integer  "attorney_patient_bill_id"
    t.datetime "onset_at"
    t.datetime "first_treated_at"
    t.integer  "diagnosis1_id"
    t.integer  "diagnosis2_id"
    t.integer  "diagnosis3_id"
    t.integer  "diagnosis4_id"
    t.string   "diagnosis1_description"
    t.string   "diagnosis2_description"
    t.string   "diagnosis3_description"
    t.string   "diagnosis4_description"
    t.text     "details"
    t.datetime "deleted_at"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "patient_visits", ["diagnosis1_id"], name: "index_patient_visits_on_diagnosis1_id", using: :btree
  add_index "patient_visits", ["diagnosis2_id"], name: "index_patient_visits_on_diagnosis2_id", using: :btree
  add_index "patient_visits", ["diagnosis3_id"], name: "index_patient_visits_on_diagnosis3_id", using: :btree
  add_index "patient_visits", ["diagnosis4_id"], name: "index_patient_visits_on_diagnosis4_id", using: :btree
  add_index "patient_visits", ["patient_case_id"], name: "index_patient_visits_on_patient_case_id", using: :btree

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

  create_table "procedure_codes", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "type_code"
    t.integer  "service_type_code"
    t.string   "modifier"
    t.integer  "tax_rate_percentage"
    t.string   "modifier2"
    t.string   "modifier3"
    t.string   "cpt_code"
    t.datetime "deleted_at"
    t.integer  "clinic_id"
    t.integer  "account_id"
    t.string   "slug"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "procedure_codes", ["account_id"], name: "index_procedure_codes_on_account_id", using: :btree
  add_index "procedure_codes", ["clinic_id"], name: "index_procedure_codes_on_clinic_id", using: :btree
  add_index "procedure_codes", ["slug"], name: "index_procedure_codes_on_slug", using: :btree

  create_table "procedure_codes_fee_schedule_labels", force: :cascade do |t|
    t.integer  "procedure_code_id"
    t.integer  "fee_schedule_label_id"
    t.float    "fee_cents"
    t.integer  "copay"
    t.boolean  "is_percentage",                    default: false
    t.float    "expected_insurance_payment_cents", default: 0.0
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
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

  create_table "referrers", force: :cascade do |t|
    t.integer  "insurance_carrier_id"
    t.string   "source"
    t.string   "upin_uid"
    t.text     "comment"
    t.string   "npi_uid"
    t.integer  "address_id"
    t.integer  "contact_id"
    t.string   "slug"
    t.string   "account_id"
    t.datetime "deleted_at"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "referrers", ["account_id"], name: "index_referrers_on_account_id", using: :btree
  add_index "referrers", ["address_id"], name: "index_referrers_on_address_id", using: :btree
  add_index "referrers", ["contact_id"], name: "index_referrers_on_contact_id", using: :btree
  add_index "referrers", ["insurance_carrier_id"], name: "index_referrers_on_insurance_carrier_id", using: :btree
  add_index "referrers", ["slug"], name: "index_referrers_on_slug", using: :btree

  create_table "subscription_affiliates", force: :cascade do |t|
    t.string   "name"
    t.decimal  "rate",       precision: 6, scale: 4, default: 0.0
    t.string   "token"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
  end

  create_table "subscription_discounts", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.decimal  "amount",                 precision: 6, scale: 2, default: 0.0
    t.boolean  "percent",                                        default: false
    t.date     "start_on"
    t.date     "end_on"
    t.boolean  "apply_to_setup",                                 default: true
    t.boolean  "apply_to_recurring",                             default: true
    t.integer  "trial_period_extension",                         default: 0
    t.datetime "created_at",                                                     null: false
    t.datetime "updated_at",                                                     null: false
  end

  create_table "subscription_payments", force: :cascade do |t|
    t.integer  "account_id"
    t.integer  "subscription_id"
    t.decimal  "amount",                    precision: 10, scale: 2, default: 0.0
    t.string   "transaction_id"
    t.boolean  "setup",                                              default: false
    t.boolean  "misc",                                               default: false
    t.integer  "subscription_affiliate_id"
    t.decimal  "affiliate_amount",          precision: 6,  scale: 2, default: 0.0
    t.datetime "created_at",                                                         null: false
    t.datetime "updated_at",                                                         null: false
  end

  add_index "subscription_payments", ["account_id"], name: "index_subscription_payments_on_account_id", using: :btree
  add_index "subscription_payments", ["subscription_id"], name: "index_subscription_payments_on_subscription_id", using: :btree

  create_table "subscription_plans", force: :cascade do |t|
    t.integer  "plan_id"
    t.string   "name"
    t.decimal  "amount",                                precision: 10, scale: 2
    t.integer  "user_limit"
    t.integer  "renewal_period",                                                 default: 1
    t.decimal  "setup_amount",                          precision: 10, scale: 2
    t.integer  "trial_period",                                                   default: 1
    t.integer  "patient_limit"
    t.integer  "events_limit"
    t.integer  "emarketing_campaigns_limit_per_month"
    t.integer  "clinic_limit"
    t.integer  "office_staff_limit"
    t.integer  "provider_limit"
    t.integer  "file_storage_limit_megabytes"
    t.boolean  "is_import_export_limited"
    t.boolean  "is_hcfa_printing_limited"
    t.boolean  "is_invoicing_limited"
    t.boolean  "time_tracking"
    t.boolean  "is_appointment_scheduling_limited"
    t.boolean  "online_patient_scheduling"
    t.boolean  "website_templates"
    t.boolean  "vendor_integration"
    t.boolean  "inventory_tracking"
    t.boolean  "own_domain_name"
    t.boolean  "soap_note_report_writer"
    t.boolean  "address_verification"
    t.boolean  "labs_integration"
    t.boolean  "user_tracking_and_auditing"
    t.boolean  "daily_backups"
    t.boolean  "bookkeeping"
    t.boolean  "custom_transaction_gateway"
    t.decimal  "yearly_amount",                         precision: 10
    t.boolean  "is_user_tracking_and_auditing_limited"
    t.boolean  "is_online_patient_scheduling_limited"
    t.boolean  "is_website_templates_limited"
    t.boolean  "is_office_staff_unlimited"
    t.datetime "created_at",                                                                 null: false
    t.datetime "updated_at",                                                                 null: false
  end

  add_index "subscription_plans", ["plan_id"], name: "index_subscription_plans_on_plan_id", using: :btree

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "account_id"
    t.decimal  "amount",                   precision: 10, scale: 2
    t.datetime "next_renewal_at"
    t.string   "state",                                             default: "trial"
    t.integer  "subscription_plan_id"
    t.integer  "subscription_discount_id",                          default: 0
    t.datetime "created_at",                                                          null: false
    t.datetime "updated_at",                                                          null: false
  end

  add_index "subscriptions", ["account_id"], name: "index_subscriptions_on_account_id", using: :btree

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
