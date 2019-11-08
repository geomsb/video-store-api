require "test_helper"

describe Customer do
  describe "relationships" do
    it "can have many rentals" do
      customer = Customer.first
      movie = Movie.first

      rental = Rental.create(movie: movie, customer: customer)
      
      expect(customer.rentals.count).must_be :>, 0
      customer.rentals.each do |rental|
        expect(rental).must_be_instance_of Rental
      end
    end
  end

  describe "custom methods" do
    describe "check_out_movie" do
      it "increases the movies checked out count of a customer by 1" do
        customer = Customer.first

        customer.check_out_movie
  
        expect(customer.movies_checked_out_count).must_equal 1
      end 
    end

    describe "check_in_movie" do
      it "descreases movies checked out count of a customer by 1" do
        customer = customers(:sarah)
        customer.check_out_movie
        
        customer.check_in_movie

        expect(customer.movies_checked_out_count).must_equal 0
      end
    end
  end
end
