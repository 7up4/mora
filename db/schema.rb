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

ActiveRecord::Schema.define(version: 20170422170934) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "author_books", force: :cascade do |t|
    t.integer  "author_id"
    t.integer  "book_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_author_books_on_author_id", using: :btree
    t.index ["book_id"], name: "index_author_books_on_book_id", using: :btree
  end

  create_table "authors", force: :cascade do |t|
    t.string   "first_name",            null: false
    t.string   "last_name",             null: false
    t.string   "second_name"
    t.string   "gender",      limit: 1, null: false
    t.text     "biography"
    t.string   "photo"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "reader_id"
    t.index ["reader_id"], name: "index_authors_on_reader_id", using: :btree
  end

  create_table "book_genres", force: :cascade do |t|
    t.integer  "book_id"
    t.integer  "genre_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_book_genres_on_book_id", using: :btree
    t.index ["genre_id"], name: "index_book_genres_on_genre_id", using: :btree
  end

  create_table "book_publishers", force: :cascade do |t|
    t.integer  "book_id"
    t.integer  "publisher_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["book_id"], name: "index_book_publishers_on_book_id", using: :btree
    t.index ["publisher_id"], name: "index_book_publishers_on_publisher_id", using: :btree
  end

  create_table "book_readers", force: :cascade do |t|
    t.integer  "book_id"
    t.integer  "reader_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_book_readers_on_book_id", using: :btree
    t.index ["reader_id"], name: "index_book_readers_on_reader_id", using: :btree
  end

  create_table "books", force: :cascade do |t|
    t.string   "title",               null: false
    t.date     "date_of_publication"
    t.text     "annotation",          null: false
    t.integer  "volume",              null: false
    t.string   "language",            null: false
    t.string   "cover"
    t.string   "book_file"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "genres", force: :cascade do |t|
    t.string   "genre_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["genre_name"], name: "index_genres_on_genre_name", unique: true, using: :btree
  end

  create_table "publishers", force: :cascade do |t|
    t.string   "publisher_name",     null: false
    t.string   "publisher_location"
    t.string   "publisher_logo"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "reader_id"
    t.index ["publisher_name"], name: "index_publishers_on_publisher_name", unique: true, using: :btree
    t.index ["reader_id"], name: "index_publishers_on_reader_id", using: :btree
  end

  create_table "readers", force: :cascade do |t|
    t.string   "first_name",                                        null: false
    t.string   "last_name",                                         null: false
    t.string   "second_name"
    t.string   "gender",                 limit: 1,                  null: false
    t.string   "nick",                   limit: 25,                 null: false
    t.date     "birthdate"
    t.string   "avatar"
    t.boolean  "admin",                             default: false
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "email",                             default: "",    null: false
    t.string   "encrypted_password",                default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.index ["email"], name: "index_readers_on_email", unique: true, using: :btree
    t.index ["nick"], name: "index_readers_on_nick", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_readers_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "author_books", "authors"
  add_foreign_key "author_books", "books"
  add_foreign_key "authors", "readers"
  add_foreign_key "book_genres", "books"
  add_foreign_key "book_genres", "genres"
  add_foreign_key "book_publishers", "books"
  add_foreign_key "book_publishers", "publishers"
  add_foreign_key "book_readers", "books"
  add_foreign_key "book_readers", "readers"
  add_foreign_key "publishers", "readers"
end
