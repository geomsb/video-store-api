class Movie < ApplicationRecord
  has_many :rentals

  validates :title, :overview, :release_date, presence: true
  validates :inventory, numericality: true, presence: true
end
