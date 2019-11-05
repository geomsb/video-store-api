class AddCounterToCustomer < ActiveRecord::Migration[5.2]
  def change
    add_column :customers, :movies_checked_out_count, :integer
  end
end
