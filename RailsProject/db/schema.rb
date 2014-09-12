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

ActiveRecord::Schema.define(version: 20140909034410) do

  create_table "accesses", force: true do |t|
    t.integer  "group_id"
    t.string   "controllerName"
    t.string   "actionName"
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
    t.string   "numberStreet"
    t.string   "complement",   null: false
    t.string   "street"
    t.string   "city"
    t.string   "country"
    t.string   "zipcode"
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
    t.integer  "user_id"
    t.integer  "album_id"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "albums", force: true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "style"
    t.float    "price"
    t.string   "file"
    t.integer  "yearProd"
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
    t.string   "url"
    t.integer  "file_size"
    t.string   "content_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attachments_news", id: false, force: true do |t|
    t.integer "news_id",       null: false
    t.integer "attachment_id", null: false
  end

  create_table "battles", force: true do |t|
    t.datetime "date_begin"
    t.datetime "date_end"
    t.integer  "artist_one_id"
    t.integer  "artist_two_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "carts", force: true do |t|
    t.integer  "user_id"
    t.string   "typeObj"
    t.integer  "obj_id"
    t.boolean  "gift"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "commentaries", force: true do |t|
    t.integer  "author_id"
    t.text     "content"
    t.datetime "create_at"
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
    t.integer  "user_id"
    t.datetime "planification"
    t.integer  "address_id"
    t.string   "url",           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "descriptions", force: true do |t|
    t.text     "description"
    t.string   "language"
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
    t.integer  "music_id"
    t.string   "file"
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
    t.string   "style_name"
    t.string   "color_name"
    t.string   "color_hexa"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genres_influences", id: false, force: true do |t|
    t.integer "influence_id", null: false
    t.integer "genre_id",     null: false
  end

  create_table "gifts", force: true do |t|
    t.integer  "to_user"
    t.integer  "from_user"
    t.string   "typeObj"
    t.integer  "obj_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups_users", id: false, force: true do |t|
    t.integer "user_id",  null: false
    t.integer "group_id", null: false
  end

  create_table "influences", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "listenings", force: true do |t|
    t.integer  "user_id"
    t.integer  "music_id"
    t.datetime "when"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: true do |t|
    t.text     "msg"
    t.integer  "user_id"
    t.integer  "dest_id"
    t.string   "session"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "music_notes", force: true do |t|
    t.integer  "user_id"
    t.integer  "album_id"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "musics", force: true do |t|
    t.integer  "user_id"
    t.integer  "album_id"
    t.string   "title"
    t.integer  "duration"
    t.string   "style"
    t.float    "price"
    t.string   "file"
    t.boolean  "limited"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "musics_playlists", id: false, force: true do |t|
    t.integer "music_id",    null: false
    t.integer "playlist_id", null: false
  end

  create_table "news", force: true do |t|
    t.string   "title"
    t.datetime "date"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "newstexts", force: true do |t|
    t.text     "content"
    t.string   "title"
    t.string   "language"
    t.integer  "news_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", force: true do |t|
    t.integer  "user_id"
    t.string   "link"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "packs", force: true do |t|
    t.string   "title"
    t.string   "style"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "playlists", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "propositions", force: true do |t|
    t.integer  "artist_id"
    t.integer  "album_id"
    t.integer  "state"
    t.datetime "date_posted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "purchases", force: true do |t|
    t.integer  "user_id"
    t.string   "typeObj"
    t.integer  "obj_id"
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", force: true do |t|
    t.string   "tag"
    t.integer  "news_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tweets", force: true do |t|
    t.text     "msg"
    t.string   "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "password"
    t.string   "salt"
    t.string   "fname",       null: false
    t.string   "lname",       null: false
    t.string   "username"
    t.date     "birthday"
    t.string   "image"
    t.text     "description", null: false
    t.string   "phoneNumber", null: false
    t.integer  "adress_id",   null: false
    t.string   "facebook",    null: false
    t.string   "twitter",     null: false
    t.string   "googlePlus",  null: false
    t.datetime "signin"
    t.string   "idAPI"
    t.string   "secureKey"
    t.boolean  "activated"
    t.boolean  "newsletter"
    t.string   "language"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "votes", force: true do |t|
    t.integer  "user_id"
    t.integer  "battle_id"
    t.integer  "artist_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
