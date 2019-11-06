class Movie < ApplicationRecord
  has_many :rentals

  validates :title, :overview, :release_date, presence: true
  validates :inventory, numericality: true, presence: true

  def check_out
    if movie.available_inventory > 1
      movie.available_inventory = movie.available_inventory -1
      movie.save
      return true
    else
      return false
    end
  end

  def check_in
    movie.available_inventory = movie.available_inventory + 1
    movie.save
  end
end
