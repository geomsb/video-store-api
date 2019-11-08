class Movie < ApplicationRecord
  after_create :set_avail_inv

  has_many :rentals

  validates :title, :overview, :release_date, :inventory, presence: true
  validates_numericality_of :inventory, greater_than: 0
  
  def movie_avail?
    if self.available_inventory >= 1
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

  def set_avail_inv
    self.available_inventory ||= self.inventory
  end
end
