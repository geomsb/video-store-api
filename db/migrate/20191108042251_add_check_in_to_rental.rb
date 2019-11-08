class AddCheckInToRental < ActiveRecord::Migration[5.2]
  def change
    add_column :rentals, :check_in, :date
  end
end
