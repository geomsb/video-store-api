class Movie < ApplicationRecord
  before_save :set_avail_inv, except: [:update, :index, :show]

  has_many :rentals

  validates :title, :overview, :release_date, :inventory, presence: true
  validates_numericality_of :inventory
  
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
