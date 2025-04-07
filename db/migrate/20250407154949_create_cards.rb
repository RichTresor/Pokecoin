class CreateCards < ActiveRecord::Migration[8.0]
  def change
    create_table :cards do |t|
      t.string :name
      t.string :rarity
      t.string :image_url
      t.decimal :last_price
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
