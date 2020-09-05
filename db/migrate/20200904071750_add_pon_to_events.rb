class AddPonToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :pon, :boolean, default: true, null: false
  end
end
