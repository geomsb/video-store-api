require "test_helper"

describe Rental do
  describe "relationships" do
    before do
      @customer = customers(:betsy)
      @movie = movies(:new_movie)
    end

    it "can set the customer through 'customer'" do
      rental = Rental.new(movie_id: @movie.id)
      rental.customer = @customer

      expect(rental.customer_id).must_equal @customer.id
    end

    it "can set the customer through 'customer_id'" do
      rental = Rental.new(movie_id: @movie.id)
      rental.customer_id = @customer.id

      expect(rental.customer).must_equal @customer

    end

    it "can set the movie through 'movie'" do
      rental = Rental.new(customer_id: @customer.id)
      rental.movie = @movie

      expect(rental.movie_id).must_equal @movie.id
    end

    it "can set the movie through 'movie_id'" do
      rental = Rental.new(customer_id: @customer.id)
      rental.movie_id = @movie.id

      expect(rental.movie).must_equal @movie
    end
  end

  describe "custom methods" do
    describe "set_due_date" do
      it "sets the due date to 7 days after the check_out date" do
        rental = Rental.new(movie: Movie.first, customer: Customer.first)
        rental.check_out = Date.today

        rental.set_due_date

        expect(rental.due_date).must_equal (Date.today + 7)
      end
    end
  end
end
