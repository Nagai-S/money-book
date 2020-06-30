class RemoveNameBeforeFromAccount < ActiveRecord::Migration[5.1]
  def change
    remove_column :accounts, :name_before, :string
  end
end
