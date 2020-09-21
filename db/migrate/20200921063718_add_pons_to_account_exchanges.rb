class AddPonsToAccountExchanges < ActiveRecord::Migration[5.1]
  def change
    add_column :account_exchanges, :pay_date, :date
    add_column :account_exchanges, :pon, :boolean, default: true, null: false
  end
end
