require "test_helper"

describe Movie do
  describe "validations" do
    before do
      @movies = Movie.all
    end

    it "can be valid" do
      @movies.each do |movie|
        assert(movie.valid?)
      end
    end

    it "will have the required fields" do
      @movies.each do |movie|
        [:title, :overview, :release_date, :inventory].each do |field|
          expect(movie).must_respond_to field
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

  describe "custom methods" do
    describe "movie_avail?" do
      it "returns true if available inventory is greater than 0" do
        movie = Movie.first
        available = movie.available_inventory

        result = movie.movie_avail?

        expect(result).must_equal true
      end

      it "returns false if available inventory is 0" do
        movie = Movie.last
        movie.update(available_inventory: 0)

        result = movie.movie_avail?

        expect(result).must_equal false
        expect(movie.available_inventory).must_equal 0
      end
    end

    describe "reduce_avail_inv" do
      it "reduces available inventory by 1" do
        movie = Movie.last
        available = movie.available_inventory

        movie.reduce_avail_inv

        expect(movie.available_inventory).must_equal (available - 1)
      end
    end

    describe "increase_avail_inv" do
      it "increases available inventory by 1" do
        movie = Movie.last
        available = movie.available_inventory

        movie.increase_avail_inv

        expect(movie.available_inventory).must_equal (available + 1)
      end 
    end
  end
end
