class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.string :payer
      t.integer :points
      t.timestamp :date

      t.timestamps
    end
  end
end
