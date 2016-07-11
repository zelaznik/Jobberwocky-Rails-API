class CreateSessions < ActiveRecord::Migration
  def up
    create_table :sessions do |t|
      t.integer :user_id, null: false, index: true
      t.string :token, null: false, unique: true
      t.datetime :expire_date

      t.timestamps
    end

    add_index :sessions, :token, unique: true
    add_foreign_key :sessions, :users, on_delete: :cascade
  end
end
