class AddCheckoutAndDueDateToRentals < ActiveRecord::Migration[5.2]
  def change
    add_column :rentals, :check_out, :date
    add_column :rentals, :due_date, :date
  end
end
