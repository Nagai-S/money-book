class AddExchangeValueToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :exchange_value, :string
  end
end
