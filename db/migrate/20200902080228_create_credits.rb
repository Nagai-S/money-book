class CreateCredits < ActiveRecord::Migration[5.1]
  def change
    create_table :credits do |t|
      t.string :name
      t.date :pay_date
      t.date :month_date
      t.string :account
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
