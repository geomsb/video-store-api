require "test_helper"

describe Movie do
  before do
    @movies = Movie.all
  end

  describe "validations" do
    it "can be valid" do
      @movies.each do |movie|
        assert(movie.valid?)
      end
    end

    it "will have the required fields" do
      @movies.each do |movie|
        [:title, :overview, :release_date].each do |field|
          expect(item).must_respond_to field
        end
      end

    end

  end

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
