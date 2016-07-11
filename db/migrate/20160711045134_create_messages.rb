class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :sender_id, null: false
      t.integer :receiver_id, null: false
      t.string :thread_id, null: false
      t.text :body, null: false

      t.timestamps null: false
    end

    add_index :messages, :thread_id
    add_index :messages, :sender_id
    add_index :messages, :receiver_id
    add_index :messages, :created_at

    add_foreign_key :messages, :users, column: :sender_id, on_delete: :cascade
    add_foreign_key :messages, :users, column: :receiver_id, on_delete: :cascade
  end
end
