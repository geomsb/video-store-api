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
end
