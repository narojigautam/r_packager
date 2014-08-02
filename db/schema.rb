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

ActiveRecord::Schema.define(version: 20140802113220) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authors", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authors", ["email"], name: "index_authors_on_email", using: :btree

  create_table "r_packages", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "title"
    t.date     "date_created"
    t.string   "license"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "r_packages", ["name"], name: "index_r_packages_on_name", using: :btree
  add_index "r_packages", ["title"], name: "index_r_packages_on_title", using: :btree

  create_table "version_committers", force: true do |t|
    t.integer "author_id"
    t.integer "version_id"
    t.string  "role"
  end

  create_table "versions", force: true do |t|
    t.string   "number"
    t.string   "author"
    t.date     "released_on"
    t.string   "dependency"
    t.boolean  "lazy_data"
    t.string   "repository"
    t.integer  "r_package_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "versions", ["author"], name: "index_versions_on_author", using: :btree
  add_index "versions", ["number"], name: "index_versions_on_number", using: :btree

end
