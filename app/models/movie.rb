class Movie < ApplicationRecord
  has_many :rentals

  validates :title, :overview, :release_date, presence: true
  validates :inventory, numericality: true, presence: true

  def movie_avail?
    if movie.available_inventory > 1
      return true
    else
      return false
    end
  end

  def reduce_avail_inv
    movie.available_inventory = movie.available_inventory -1
    movie.save
  end

  def check_in
    movie.available_inventory = movie.available_inventory + 1
    movie.save
  end
end
