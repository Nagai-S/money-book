class RemoveExchangeValueFromAccount < ActiveRecord::Migration[5.1]
  def change
    remove_column :accounts, :exchange_value, :string
  end
end
