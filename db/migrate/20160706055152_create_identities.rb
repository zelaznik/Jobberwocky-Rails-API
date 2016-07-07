class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.references :user, force: :cascade
      t.string :provider, null: false
      t.string :uid, null: false

      t.json :raw

      t.string :name
      t.string :link, unique: true
      t.string :image

      t.timestamps
    end
  end
end
