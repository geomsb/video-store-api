class Movie < ApplicationRecord
  has_many :rentals

  validates :title, :overview, :release_date, presence: true
  validates :inventory, numericality: true, presence: true

  def movie_avail?
    if self.available_inventory > 1
      self.reduce_avail_inv
      return true
    else
      return false
    end
  end

  def reduce_avail_inv
    self.available_inventory = self.available_inventory - 1
    self.save
  end

  def check_in
    self.available_inventory = self.available_inventory + 1
    self.save
  end
end
