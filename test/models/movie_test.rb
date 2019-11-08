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
      it "returns true if available inventory is greater than 0 and decreases available inventory by 1" do
        movie = Movie.first
        available = movie.available_inventory


        result = movie.movie_avail?

        expect(result).must_equal true
        expect(movie.available_inventory).must_equal (available - 1)
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

      #edge case?
    end

    #TODO
    # describe "check_in" do
    #   it "" do
    #   end
    # end

    describe "set_avail_inv" do
      it "sets available inventory to inventory when a new movie is created" do
        movie_1 = Movie.create(
          title: "Pan's Labyrinth",
          overview: "An interesting film",
          release_date: "2009-10-03",
          inventory: 2
        )

        movie_2 = Movie.new(
          title: "Pitch Perfect",
          overview: "A movie about acapella",
          release_date: "2009-10-10",
          inventory: 3
        )
        movie_2.save

        expect(movie_1.available_inventory).must_equal movie_1.inventory
        expect(movie_2.available_inventory).must_equal movie_2.inventory
      end

      it "does not change available inventory when a movie is updated" do
        movie_1 = Movie.create(
          title: "Pan's Labyrinth",
          overview: "An interesting film",
          release_date: "2009-10-03",
          inventory: 2
        )

        movie_1.reduce_avail_inv
        movie_1.update(release_date: "2006-12-29")

        expect(movie_1.available_inventory).must_equal 1
      end
    end
  end
end
