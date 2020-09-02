class AddPayDateToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :pay_date, :date
  end
end
