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

ActiveRecord::Schema.define(version: 20141012054200) do

  create_table "accesses", force: true do |t|
    t.integer  "group_id",       null: false
    t.string   "controllerName", null: false
    t.string   "actionName",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"

  create_table "addresses", force: true do |t|
    t.string   "numberStreet", null: false
    t.string   "complement"
    t.string   "street",       null: false
    t.string   "city",         null: false
    t.string   "country",      null: false
    t.string   "zipcode",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true

  create_table "album_notes", force: true do |t|
    t.integer  "user_id",    null: false
    t.integer  "album_id",   null: false
    t.integer  "value",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "albums", force: true do |t|
    t.integer  "user_id",    null: false
    t.string   "title",      null: false
    t.string   "style",      null: false
    t.float    "price",      null: false
    t.string   "file",       null: false
    t.integer  "yearProd",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "albums_commentaries", id: false, force: true do |t|
    t.integer "commentary_id", null: false
    t.integer "album_id",      null: false
  end

  create_table "albums_descriptions", id: false, force: true do |t|
    t.integer "description_id", null: false
    t.integer "album_id",       null: false
  end

  create_table "albums_packs", id: false, force: true do |t|
    t.integer "album_id", null: false
    t.integer "pack_id",  null: false
  end

  create_table "attachments", force: true do |t|
    t.string   "url",          null: false
    t.integer  "file_size",    null: false
    t.string   "content_type", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attachments_news", id: false, force: true do |t|
    t.integer "news_id",       null: false
    t.integer "attachment_id", null: false
  end

  create_table "battles", force: true do |t|
    t.datetime "date_begin",    null: false
    t.datetime "date_end",      null: false
    t.integer  "artist_one_id", null: false
    t.integer  "artist_two_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "carts", force: true do |t|
    t.integer  "user_id",    null: false
    t.string   "typeObj",    null: false
    t.integer  "obj_id",     null: false
    t.boolean  "gift",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "commentaries", force: true do |t|
    t.integer  "author_id",  null: false
    t.text     "content",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "commentaries_musics", id: false, force: true do |t|
    t.integer "commentary_id", null: false
    t.integer "music_id",      null: false
  end

  create_table "commentaries_news", id: false, force: true do |t|
    t.integer "commentary_id", null: false
    t.integer "news_id",       null: false
  end

  create_table "concerts", force: true do |t|
    t.integer  "user_id",       null: false
    t.datetime "planification", null: false
    t.integer  "address_id",    null: false
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "descriptions", force: true do |t|
    t.text     "description", null: false
    t.string   "language",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "descriptions_genres", id: false, force: true do |t|
    t.integer "description_id", null: false
    t.integer "genre_id",       null: false
  end

  create_table "descriptions_influences", id: false, force: true do |t|
    t.integer "description_id", null: false
    t.integer "influence_id",   null: false
  end

  create_table "descriptions_musics", id: false, force: true do |t|
    t.integer "description_id", null: false
    t.integer "music_id",       null: false
  end

  create_table "flacs", force: true do |t|
    t.integer  "music_id",   null: false
    t.string   "file",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "follows", id: false, force: true do |t|
    t.integer "user_id",   null: false
    t.integer "follow_id", null: false
  end

  create_table "friends", id: false, force: true do |t|
    t.integer "user_id",   null: false
    t.integer "friend_id", null: false
  end

  create_table "genres", force: true do |t|
    t.string   "style_name", null: false
    t.string   "color_name", null: false
    t.string   "color_hexa", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genres_influences", id: false, force: true do |t|
    t.integer "influence_id", null: false
    t.integer "genre_id",     null: false
  end

  create_table "gifts", force: true do |t|
    t.integer  "to_user",    null: false
    t.integer  "from_user",  null: false
    t.string   "typeObj",    null: false
    t.integer  "obj_id",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups_users", id: false, force: true do |t|
    t.integer "user_id",  null: false
    t.integer "group_id", null: false
  end

  create_table "influences", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "listenings", force: true do |t|
    t.integer  "user_id",    null: false
    t.integer  "music_id",   null: false
    t.datetime "when",       null: false
    t.float    "latitude",   null: false
    t.float    "longitude",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: true do |t|
    t.text     "msg",        null: false
    t.integer  "user_id",    null: false
    t.integer  "dest_id",    null: false
    t.string   "session",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "music_notes", force: true do |t|
    t.integer  "user_id",    null: false
    t.integer  "music_id",   null: false
    t.integer  "value",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "musics", force: true do |t|
    t.integer  "user_id",    null: false
    t.integer  "album_id",   null: false
    t.string   "title",      null: false
    t.integer  "duration",   null: false
    t.string   "style",      null: false
    t.float    "price",      null: false
    t.string   "file",       null: false
    t.boolean  "limited",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "musics_playlists", id: false, force: true do |t|
    t.integer "music_id",    null: false
    t.integer "playlist_id", null: false
  end

  create_table "news", force: true do |t|
    t.string   "title",      null: false
    t.datetime "date",       null: false
    t.integer  "author_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "newstexts", force: true do |t|
    t.text     "content",    null: false
    t.string   "title",      null: false
    t.string   "language",   null: false
    t.integer  "news_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", force: true do |t|
    t.integer  "user_id",     null: false
    t.string   "link",        null: false
    t.string   "description", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "packs", force: true do |t|
    t.string   "title",      null: false
    t.string   "style",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "playlists", force: true do |t|
    t.integer  "user_id",    null: false
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "propositions", force: true do |t|
    t.integer  "artist_id",   null: false
    t.integer  "album_id",    null: false
    t.integer  "state",       null: false
    t.datetime "date_posted", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "purchases", force: true do |t|
    t.integer  "user_id",    null: false
    t.string   "typeObj",    null: false
    t.integer  "obj_id",     null: false
    t.datetime "date",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", force: true do |t|
    t.string   "tag",        null: false
    t.integer  "news_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tweets", force: true do |t|
    t.text     "msg",        null: false
    t.string   "user_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",       null: false
    t.string   "password",    null: false
    t.string   "salt",        null: false
    t.string   "fname"
    t.string   "lname"
    t.string   "username",    null: false
    t.date     "birthday",    null: false
    t.string   "image",       null: false
    t.text     "description"
    t.string   "phoneNumber"
    t.integer  "address_id"
    t.string   "facebook"
    t.string   "twitter"
    t.string   "googlePlus"
    t.datetime "signin",      null: false
    t.string   "idAPI",       null: false
    t.string   "secureKey",   null: false
    t.boolean  "activated",   null: false
    t.boolean  "newsletter",  null: false
    t.string   "language",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "votes", force: true do |t|
    t.integer  "user_id",    null: false
    t.integer  "battle_id",  null: false
    t.integer  "artist_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
