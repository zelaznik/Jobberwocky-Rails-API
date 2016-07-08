class AddForeignKeyToIdentities < ActiveRecord::Migration
  def change
    add_foreign_key :identities, :users, column: :user_id, on_delete: :cascade
  end
end
