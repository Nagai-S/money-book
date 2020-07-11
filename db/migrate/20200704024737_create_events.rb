class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.date :date
      t.string :genre
      t.integer :value
      t.string :account
      t.string :memo
      t.boolean :iae, default: true, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
