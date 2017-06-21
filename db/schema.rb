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

ActiveRecord::Schema.define(version: 20170429120508) do

  create_table "addresses", primary_key: "address_id", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.string "participant_id", limit: 40,                     null: false
    t.string "address_line_1", limit: 24
    t.string "address_line_2", limit: 24
    t.string "postal_code",    limit: 24,                     null: false
    t.string "city",           limit: 24
    t.string "province",       limit: 24
    t.string "us_state_id",    limit: 3,  default: "99"
    t.string "region",         limit: 40
    t.string "country_id",     limit: 3,  default: "99"
    t.string "address_type",   limit: 13, default: "primary"
    t.index ["participant_id"], name: "FK_1357", using: :btree
  end

  create_table "categories", id: :integer, default: 99, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.string "category_type", limit: 50, null: false
    t.index ["category_type"], name: "UK_5le3ghmfrckg818rfx1xja57o", unique: true, using: :btree
    t.index ["category_type"], name: "category_type_index", using: :btree
    t.index ["category_type"], name: "uc_category_type", unique: true, using: :btree
  end

  create_table "communities", primary_key: "community_id", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.string   "community_name", limit: 50
    t.integer  "approved",                   default: 0
    t.string   "first_name",     limit: 24
    t.string   "mi",             limit: 1
    t.string   "last_name",      limit: 24
    t.string   "address_line_1", limit: 24
    t.string   "address_line_2", limit: 24
    t.string   "postal_code",    limit: 24
    t.string   "city",           limit: 24
    t.string   "province",       limit: 24
    t.string   "us_state_id",    limit: 2
    t.string   "country_id",     limit: 2
    t.string   "home_phone",     limit: 20
    t.string   "cell_phone",     limit: 20
    t.string   "email",          limit: 100
    t.integer  "is_active"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.datetime "date_deleted",                           null: false
    t.string   "region",         limit: 40
    t.string   "remote_ip",      limit: 24
  end

  create_table "contact_describes", primary_key: "contact_describe_id", id: :string, limit: 2, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.string  "purpose_type",            limit: 10
    t.integer "option_value",                        default: 99, null: false
    t.string  "borrower_or_lender_text", limit: 100
  end

  create_table "contact_preferences", primary_key: "contact_preference_id", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.string   "participant_id",                       limit: 40
    t.string   "item_id",                              limit: 40
    t.integer  "use_which_contact_address"
    t.integer  "contact_by_chat"
    t.integer  "contact_by_email"
    t.integer  "contact_by_home_phone"
    t.integer  "contact_by_cell_phone"
    t.integer  "contact_by_alternative_phone"
    t.string   "contact_by_Facebook",                  limit: 30
    t.string   "contact_by_Twitter",                   limit: 30
    t.string   "contact_by_Instagram",                 limit: 30
    t.string   "contact_by_LinkedIn",                  limit: 30
    t.string   "contact_by_other_social_media",        limit: 30
    t.string   "contact_by_other_social_media_access", limit: 30
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.datetime "date_deleted",                                    null: false
    t.index ["participant_id"], name: "FK_g9x1taox6ptxbnbrs74y9a8qe", using: :btree
  end

  create_table "contacts", primary_key: "contact_id", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.string   "user_id",    limit: 40
    t.string   "subject",    limit: 40,  null: false
    t.string   "remote_ip",  limit: 50
    t.string   "email",      limit: 100, null: false
    t.string   "comments",               null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "countries", primary_key: "country_id", id: :string, limit: 2, default: "", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.string "country_name", limit: 32
  end

  create_table "getipaddresses", id: false, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.string   "user_ip_address", limit: 40
    t.datetime "date_created",                default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string   "whois",           limit: 175
    t.index ["date_created"], name: "date_created", using: :btree
  end

  create_table "homes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "item_conditions", id: :integer, default: 99, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.string "condition", limit: 50, null: false
  end

  create_table "item_images", primary_key: "item_image_id", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.string   "item_id",            limit: 40,  null: false
    t.string   "image_content_type", limit: 20
    t.integer  "image_height"
    t.integer  "image_width"
    t.string   "image_file_name",    limit: 150, null: false
    t.string   "item_image_caption", limit: 50
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.datetime "date_deleted"
    t.index ["item_id"], name: "FK_am3u4g1hvhrm16k7a5tevnm67", using: :btree
  end

  create_table "items", primary_key: "item_id", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.string   "participant_id",      limit: 40
    t.integer  "category_id",                    default: 99
    t.string   "other_item_category", limit: 24
    t.string   "item_model",          limit: 24
    t.string   "item_description",    limit: 50
    t.integer  "item_condition_id"
    t.integer  "item_count"
    t.string   "comment"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.datetime "date_deleted",                                null: false
    t.integer  "approved",                       default: 0
    t.integer  "notify",                         default: 0
    t.string   "item_type",           limit: 12
    t.string   "remote_ip",           limit: 50
    t.index ["category_id"], name: "FK_2468", using: :btree
    t.index ["participant_id"], name: "FK_52tac6u1upkb027sw6uicl7p3", using: :btree
  end

  create_table "lender_item_conditions", primary_key: "lender_item_condition_id", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.string   "item_id",                         limit: 40
    t.string   "participant_id",                  limit: 40
    t.integer  "for_free",                                                            default: -9
    t.integer  "available_for_purchase",                                              default: -9
    t.decimal  "available_for_purchase_amount",              precision: 10, scale: 2
    t.integer  "small_fee",                                                           default: -9
    t.decimal  "small_fee_amount",                           precision: 10, scale: 2
    t.integer  "available_for_donation",                                              default: -9
    t.integer  "donate_anonymous",                                                    default: -9
    t.integer  "trade",                                                               default: -9
    t.string   "trade_item",                      limit: 50
    t.integer  "agreed_number_of_days",                                               default: -9
    t.integer  "agreed_number_of_hours",                                              default: -9
    t.integer  "indefinite_duration",                                                 default: -9
    t.integer  "present_during_borrowing_period",                                     default: -9
    t.integer  "entire_period",                                                       default: -9
    t.integer  "partial_period",                                                      default: -9
    t.integer  "provide_proper_use_training",                                         default: -9
    t.string   "specific_conditions"
    t.decimal  "security_deposit_amount",                    precision: 10, scale: 2
    t.integer  "security_deposit",                                                    default: -9
    t.string   "remote_ip",                       limit: 50
    t.string   "comment"
    t.datetime "created_at",                                                                       null: false
    t.datetime "updated_at",                                                                       null: false
    t.datetime "date_deleted"
    t.index ["item_id"], name: "FK_ahjb6t9wt4ijtjwfvx2rt8biu", using: :btree
    t.index ["participant_id"], name: "FK_1357", using: :btree
  end

  create_table "lender_transfers", primary_key: "lender_transfer_id", id: :string, limit: 40, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.string   "item_id",                            limit: 40
    t.string   "participant_id",                     limit: 40
    t.integer  "borrower_comes_to_which_address",               default: -9
    t.integer  "meetBorrowerAtAgreed",                          default: -9
    t.integer  "meetBorrowerAtAgreedLenderChoice",              default: -9
    t.integer  "meetBorrowerAtAgreedBorrowerChoice",            default: -9
    t.integer  "meetBorrowerAtAgreedMutual",                    default: -9
    t.integer  "will_deliver_to_borrower",                      default: -9
    t.integer  "thirdPartyPresence",                            default: -9
    t.integer  "thirdPartyPresenceLenderChoice",                default: -9
    t.integer  "thirdPartyPresenceBorrowerChoice",              default: -9
    t.integer  "thirdPartyPresenceMutual",                      default: -9
    t.integer  "borrower_returns_to_which_address",             default: -9
    t.integer  "willPickUpPreferredLocation",                   default: -9
    t.string   "remote_ip",                          limit: 50
    t.string   "comment"
    t.datetime "date_created",                                               null: false
    t.datetime "date_updated",                                               null: false
    t.datetime "date_deleted",                                               null: false
    t.index ["item_id"], name: "FK_6ulch4362bwmadeo677flpuw", using: :btree
  end

  create_table "maps", primary_key: "map_id", id: :integer, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.string "key_text",   limit: 40, null: false
    t.string "value_text", limit: 40, null: false
  end

  create_table "participants", primary_key: "participant_id", id: :string, limit: 40, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.string   "user_id",                     limit: 40,                null: false
    t.string   "community_id",                limit: 40, default: "-9"
    t.integer  "contact_describe_id",                    default: -9
    t.string   "organization_name",           limit: 50
    t.integer  "display_organization",                   default: -9
    t.string   "other_describe_yourself",     limit: 24
    t.string   "first_name",                  limit: 24
    t.string   "mi",                          limit: 1
    t.string   "last_name",                   limit: 24
    t.string   "alias",                       limit: 24
    t.integer  "display_name",                           default: -9
    t.integer  "display_address",                        default: -9
    t.string   "home_phone",                  limit: 20
    t.string   "cell_phone",                  limit: 20
    t.string   "alternative_phone",           limit: 20
    t.string   "email_alternative",           limit: 50
    t.integer  "question_alt_email",                     default: 0
    t.integer  "question_alt_address",                   default: 0
    t.integer  "display_home_phone",                     default: -9
    t.integer  "display_cell_phone",                     default: -9
    t.integer  "display_alternative_phone",              default: -9
    t.integer  "display_alternative_address",            default: -9
    t.integer  "instructions",                           default: -9
    t.integer  "goodwill",                               default: -9
    t.integer  "age_18_or_more",                         default: -9
    t.integer  "is_active",                              default: -9
    t.integer  "editable",                               default: -9
    t.integer  "is_creator",                             default: -9
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.datetime "date_deleted",                                          null: false
    t.string   "remote_ip",                   limit: 50
    t.integer  "approved",                               default: 0,    null: false
    t.index ["community_id"], name: "FK_comm_id", using: :btree
    t.index ["contact_describe_id"], name: "FK_cbi", using: :btree
    t.index ["user_id"], name: "FK_user_id", using: :btree
  end

  create_table "purposes", id: :string, limit: 40, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.string  "purpose_type",  limit: 20, null: false
    t.integer "purpose_order",            null: false
    t.string  "purpose_short", limit: 20, null: false
  end

  create_table "roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "role_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "searches", id: :string, limit: 40, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.string   "keyword"
    t.string   "postal_code",        limit: 55
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "category_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "lender_or_borrower"
    t.integer  "is_community",                  null: false
    t.string   "user_id",            limit: 44, null: false
    t.integer  "zip_code_radius"
    t.string   "remote_ip",          limit: 50
  end

  create_table "us_states", us_state_id: :string, limit: 2, default: "99", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.string "state_name", limit: 30
    t.index ["state_name"], name: "state_name_2", using: :btree
  end

  create_table "user_transactions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "ledger_line_id"
    t.decimal  "line_item_amount", precision: 10
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "ledger_id"
  end

  create_table "users", primary_key: "user_id", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "username",         limit: 40,    null: false
    t.string   "community_name",   limit: 40
    t.string   "email",            limit: 100,   null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "remote_ip",        limit: 24
    t.binary   "crypted_password", limit: 65535
    t.binary   "salt",             limit: 65535
    t.string   "reset_code",       limit: 40
    t.datetime "activated_at"
    t.string   "user_alias",       limit: 40,    null: false
    t.string   "user_type",        limit: 40
    t.integer  "role_id"
    t.string   "remember_token"
    t.boolean  "acceptID"
    t.boolean  "partID"
    t.boolean  "cpID"
    t.boolean  "itemID"
    t.boolean  "licId"
    t.boolean  "litId"
  end

end
