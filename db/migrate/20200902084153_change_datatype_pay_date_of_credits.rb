class ChangeDatatypePayDateOfCredits < ActiveRecord::Migration[5.1]
  def change
    change_column :credits, :pay_date, 'integer'
  end
end
