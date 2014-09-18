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

ActiveRecord::Schema.define(version: 20140823064149) do

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
    t.string   "cprice"
    t.string   "price"
    t.string   "size"
    t.string   "description"
    t.string   "style"
    t.string   "brand"
  end

  create_table "purchase_products", force: true do |t|
    t.integer  "product_id"
    t.integer  "purchase_id"
    t.integer  "qty"
    t.float    "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "cprice"
    t.integer  "invoice_qty"
    t.integer  "received_qty"
  end

  create_table "purchases", force: true do |t|
    t.string   "invoice"
    t.integer  "supplier_id"
    t.date     "purchase_date"
    t.boolean  "paid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "receipt_type"
    t.string   "suppliers_invoice"
    t.date     "invoice_date"
    t.string   "amount"
    t.string   "transport"
    t.string   "lr_no"
    t.float    "discount"
    t.integer  "freight"
    t.integer  "dc"
    t.integer  "vat"
    t.integer  "cst"
    t.integer  "duty"
    t.integer  "edu_cess"
    t.integer  "surcharge"
    t.float    "round_off"
    t.integer  "debit_note"
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

  create_table "sale_returns", force: true do |t|
    t.integer  "sale_id"
    t.integer  "product_id"
    t.integer  "qty"
    t.float    "cprice"
    t.float    "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sale_returns", ["product_id"], name: "index_sale_returns_on_product_id", using: :btree
  add_index "sale_returns", ["sale_id"], name: "index_sale_returns_on_sale_id", using: :btree

  create_table "sales", force: true do |t|
    t.integer  "customer_id"
    t.date     "sale_date"
    t.boolean  "paid"
    t.string   "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "order"
    t.string   "invoice"
    t.float    "discount",    default: 0.0
    t.integer  "vat",         default: 0
    t.string   "sale_type"
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
    t.integer  "sale_return_id"
  end

  add_index "stock_products", ["sale_return_id"], name: "index_stock_products_on_sale_return_id", using: :btree

  create_table "suppliers", force: true do |t|
    t.string   "name"
    t.string   "mobile"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "pincode"
    t.string   "state"
    t.string   "phone"
    t.string   "email"
    t.string   "contact_person"
    t.string   "tin"
    t.string   "cst"
    t.string   "pan"
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

  create_table "variant_items", force: true do |t|
    t.string   "name"
    t.integer  "variant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "variant_items", ["variant_id"], name: "index_variant_items_on_variant_id", using: :btree

  create_table "variants", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
