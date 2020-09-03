class CreateCredits < ActiveRecord::Migration[5.1]
  def change
    create_table :credits do |t|
      t.string :name
      t.integer :pay_date
      t.integer :month_date
      t.string :account
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
