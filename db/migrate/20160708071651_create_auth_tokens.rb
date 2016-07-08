class CreateAuthTokens < ActiveRecord::Migration
  def change
    create_table :auth_tokens do |t|
      t.integer :user_id, null: false, index: true
      t.string :token, null: false, unique: true
      t.datetime :issue_date
      t.datetime :expire_date

      t.timestamps
    end

    add_index :auth_tokens, :token, unique: true
    add_foreign_key :auth_tokens, :users, on_delete: :cascade
  end
end
