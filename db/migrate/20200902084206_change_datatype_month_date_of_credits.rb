class ChangeDatatypeMonthDateOfCredits < ActiveRecord::Migration[5.1]
  def up
    change_column :credits, :month_date, 'integer'
  end

  def down
    change_column :credits, :month_date, 'date'
  end
end
