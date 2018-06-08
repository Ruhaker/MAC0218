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

ActiveRecord::Schema.define(version: 20180608141857) do

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.integer "credits"
    t.string "teaching_unit"
    t.integer "expected_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.integer "min_credits"
    t.integer "min_subjects"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "course_id"
    t.integer "group_id"
  end

  create_table "groups_subjects", force: :cascade do |t|
    t.integer "group_id"
    t.integer "subject_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plans", force: :cascade do |t|
    t.integer "course_id"
    t.integer "student_id"
    t.integer "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string "browser"
    t.string "ip_address"
    t.datetime "last_accessed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "session_key"
    t.boolean "active"
    t.integer "user_id"
  end

  create_table "subject_students", force: :cascade do |t|
    t.integer "subject_id"
    t.integer "student_id"
    t.integer "progress"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subjects", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.integer "credits_class"
    t.integer "credits_work"
    t.integer "workload"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "supervises", force: :cascade do |t|
    t.integer "course_id"
    t.integer "supervisor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "pw_hash"
    t.string "pw_salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "nusp"
    t.bigint "cpf"
    t.string "type"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
