class UpdateAvailableInventory < ActiveRecord::Migration[5.2]
  def change
    remove_column :movies, :available_inventory, :integer
    add_column :movies, :available_inventory, :integer

    # Taken from: https://stackoverflow.com/questions/41743231/how-to-copy-other-columns-value-as-default-value-for-a-new-column-in-rails-migr
    reversible do |dir|
      dir.up {Movie.update_all('available_inventory = inventory')}
    end
  end
end
