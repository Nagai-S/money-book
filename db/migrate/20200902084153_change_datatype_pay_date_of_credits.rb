class ChangeDatatypePayDateOfCredits < ActiveRecord::Migration[5.1]
  def up
    change_column :credits, :pay_date, 'integer'
  end

  def down
    change_column :credits, :pay_date, 'date'
  end
end
