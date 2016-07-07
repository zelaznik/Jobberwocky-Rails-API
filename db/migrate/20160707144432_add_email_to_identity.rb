class AddEmailToIdentity < ActiveRecord::Migration
  def change
    add_column :identities, :email, :string, index: true, unique: false
  end
end
