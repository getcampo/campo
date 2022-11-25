# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2019_06_25_121526) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attachments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "token", null: false
    t.string "file", null: false
    t.string "content_type"
    t.integer "byte_size"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["token"], name: "index_attachments_on_token", unique: true
    t.index ["user_id"], name: "index_attachments_on_user_id"
  end

  create_table "forums", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.text "description"
    t.integer "topics_count", default: 0, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index "lower((slug)::text)", name: "index_forums_on_lower_slug", unique: true
  end

  create_table "identities", force: :cascade do |t|
    t.bigint "user_id"
    t.string "provider", null: false
    t.string "uid", null: false
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["uid", "provider"], name: "index_identities_on_uid_and_provider", unique: true
    t.index ["user_id"], name: "index_identities_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.integer "type", null: false
    t.boolean "read", default: false, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["record_type", "record_id"], name: "index_notifications_on_record_type_and_record_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.bigint "topic_id", null: false
    t.bigint "user_id", null: false
    t.integer "number", null: false
    t.bigint "reply_to_post_id"
    t.text "body", null: false
    t.bigint "edited_user_id"
    t.datetime "edited_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.tsvector "search_data"
    t.index ["deleted_at"], name: "index_posts_on_deleted_at"
    t.index ["edited_user_id"], name: "index_posts_on_edited_user_id"
    t.index ["reply_to_post_id"], name: "index_posts_on_reply_to_post_id"
    t.index ["search_data"], name: "index_posts_on_search_data", using: :gin
    t.index ["topic_id"], name: "index_posts_on_topic_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "reactions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "post_id", null: false
    t.integer "type", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["post_id"], name: "index_reactions_on_post_id"
    t.index ["user_id", "post_id"], name: "index_reactions_on_user_id_and_post_id", unique: true
  end

  create_table "sites", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "logo"
    t.string "icon"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "topic_id", null: false
    t.integer "status", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["topic_id"], name: "index_subscriptions_on_topic_id"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "topics", force: :cascade do |t|
    t.bigint "forum_id", null: false
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.integer "posts_count", default: 0, null: false
    t.datetime "activated_at", precision: nil, null: false
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["activated_at"], name: "index_topics_on_activated_at"
    t.index ["deleted_at"], name: "index_topics_on_deleted_at"
    t.index ["forum_id"], name: "index_topics_on_forum_id"
    t.index ["user_id"], name: "index_topics_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "name", null: false
    t.string "email", null: false
    t.boolean "email_verified", default: false
    t.string "password_digest", null: false
    t.string "avatar"
    t.text "bio"
    t.string "auth_token", null: false
    t.integer "role", default: 0
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index "lower((email)::text)", name: "index_users_on_lower_email", unique: true
    t.index "lower((username)::text)", name: "index_users_on_lower_username", unique: true
    t.index ["auth_token"], name: "index_users_on_auth_token", unique: true
  end

end
