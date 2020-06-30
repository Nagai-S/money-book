class AddNameBeforeToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :name_before, :string
  end
end
