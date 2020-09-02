class ChangeDatatypeMonthDateOfCredits < ActiveRecord::Migration[5.1]
  def change
    change_column :credits, :month_date, 'integer'
  end
end
