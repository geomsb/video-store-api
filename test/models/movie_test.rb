require "test_helper"

describe Movie do
  describe "relationships" do
    before do
      @customer = customers(:betsy)
      @movie = movies(:new_movie)
    end

    it "has many rentals" do
      rental = Rental.new(movie_id: @movie.id, customer_id: @customer.id)

      expect(@movie.rentals.count).must_be :>, 0
      @movie.rentals.each do |rental|
        expect(rental).must_be_instance_of Rental
      end
    end
  end
end
