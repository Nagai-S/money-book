class RemoveNameAfterFromAccount < ActiveRecord::Migration[5.1]
  def change
    remove_column :accounts, :name_after, :string
  end
end
