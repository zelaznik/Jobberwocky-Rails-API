class CreateEmailAccounts < ActiveRecord::Migration
  def change
    create_table :email_accounts do |t|
      t.integer :user_id, null: false
      t.string :address, null: false, unique: true
      t.timestamps null: false
    end

    add_index :email_accounts, :user_id
    add_foreign_key :email_accounts, :users, on_delete: :cascade
  end
end
