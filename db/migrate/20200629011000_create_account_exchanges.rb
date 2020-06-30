class CreateAccountExchanges < ActiveRecord::Migration[5.1]
  def change
    create_table :account_exchanges do |t|
      t.string :bname
      t.string :aname
      t.integer :value
      t.date :date
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
