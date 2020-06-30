class AddNameAfterToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :name_after, :string
  end
end
