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

ActiveRecord::Schema.define(version: 20140630131900) do

  create_table "items", force: true do |t|
    t.string   "uri"
    t.string   "name"
    t.string   "code"
    t.decimal  "price",         precision: 10, scale: 0
    t.string   "image_uri"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "on_sale_date"
    t.date     "off_sale_date"
    t.boolean  "archive",                                default: false
  end

  create_table "stages", force: true do |t|
    t.integer  "item_id"
    t.integer  "sum"
    t.integer  "category"
    t.integer  "status"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stages", ["item_id"], name: "index_stages_on_item_id", using: :btree

end
