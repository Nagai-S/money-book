class AddIaeToGenres < ActiveRecord::Migration[5.1]
  def change
    add_column :genres, :iae, :boolean, default: true, null: false
  end
end
