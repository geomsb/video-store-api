class Rental < ApplicationRecord
  belongs_to :movie
  belongs_to :customer


  def set_due_date
    self.due_date = self.check_out + 7
  end
end
