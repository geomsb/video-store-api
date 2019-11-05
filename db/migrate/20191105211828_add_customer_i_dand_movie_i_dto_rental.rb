class AddCustomerIDandMovieIDtoRental < ActiveRecord::Migration[5.2]
  def change
    add_reference :rentals, :customer, foreign_key: true
    add_reference :rentals, :movie, foreign_key: true
  end
end
