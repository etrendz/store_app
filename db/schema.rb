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

ActiveRecord::Schema.define(version: 20140406134212) do

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", force: true do |t|
    t.string   "name"
    t.string   "mobile"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "address"
    t.string   "tin"
  end

  create_table "payments", force: true do |t|
    t.integer  "amount"
    t.integer  "customer_id"
    t.integer  "sale_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payments", ["customer_id"], name: "index_payments_on_customer_id", using: :btree
  add_index "payments", ["sale_id"], name: "index_payments_on_sale_id", using: :btree

  create_table "products", force: true do |t|
    t.string   "name"
    t.integer  "category_id"
    t.string   "unit"
    t.integer  "qty",         default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code"
  end

  create_table "purchase_products", force: true do |t|
    t.integer  "product_id"
    t.integer  "purchase_id"
    t.integer  "qty"
    t.float    "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "cprice"
  end

  create_table "purchases", force: true do |t|
    t.string   "invoice"
    t.integer  "supplier_id"
    t.date     "purchase_date"
    t.boolean  "paid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sale_products", force: true do |t|
    t.integer  "product_id"
    t.integer  "sale_id"
    t.integer  "qty"
    t.float    "cprice"
    t.float    "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sales", force: true do |t|
    t.integer  "customer_id"
    t.date     "sale_date"
    t.boolean  "paid"
    t.string   "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "order"
    t.string   "dc"
    t.string   "invoice"
    t.integer  "discount",    default: 0
    t.integer  "vat",         default: 0
  end

  create_table "sold_products", force: true do |t|
    t.integer  "stock_product_id"
    t.integer  "product_id"
    t.integer  "purchase_product_id"
    t.integer  "sale_product_id"
    t.float    "price"
    t.float    "cprice"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stock_products", force: true do |t|
    t.integer  "product_id"
    t.float    "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "cprice"
    t.integer  "purchase_product_id"
    t.integer  "sale_product_id"
  end

  create_table "suppliers", force: true do |t|
    t.string   "name"
    t.string   "mobile"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "units", force: true do |t|
    t.string   "unit"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

end
