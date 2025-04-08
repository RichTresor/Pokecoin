class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.integer :buyer_id
      t.integer :seller_id
      t.integer :card_id
      t.decimal :amount, precision: 10, scale: 2  # Le montant de la transaction
      t.datetime :transaction_date, default: -> { 'CURRENT_TIMESTAMP' }

      t.timestamps
    end

    add_index :transactions, :buyer_id
    add_index :transactions, :seller_id
    add_index :transactions, :card_id
  end
end
