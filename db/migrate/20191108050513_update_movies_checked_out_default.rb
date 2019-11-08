class UpdateMoviesCheckedOutDefault < ActiveRecord::Migration[5.2]
  def change
    def change
      remove_column :customers, :movies_checked_out_count
      add_column :customers, :movies_checked_out_count, :integer, default: 0 
    end
  end
end
