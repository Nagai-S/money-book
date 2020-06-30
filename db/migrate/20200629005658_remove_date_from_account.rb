class RemoveDateFromAccount < ActiveRecord::Migration[5.1]
  def change
    remove_column :accounts, :date, :date
  end
end
