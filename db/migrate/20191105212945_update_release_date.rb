class UpdateReleaseDate < ActiveRecord::Migration[5.2]
  def change
    remove_column :movies, :realease_date
    add_column :movies, :release_date, :datetime
  end
end
