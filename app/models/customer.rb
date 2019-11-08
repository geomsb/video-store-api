class Customer < ApplicationRecord
  before_save :set_default_checked_out
  has_many :rentals


  def set_default_checked_out
    self.movies_checked_out_count = 0 unless self.movies_checked_out_count
  end

  def increase_checked_out_count
    self.movies_checked_out_count += 1
  end
end
