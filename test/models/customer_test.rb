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
    describe "set_default_checked_out" do
      it "sets movies_checked_out_count to 0" do
        customer = Customer.new(name: "Sarah")
        customer.set_default_checked_out

        expect(customer.movies_checked_out_count).must_equal 0
      end
    end

    describe "increase_checked_out_count" do
      it "increases the movies checked out count of a customer by 1" do
        customer = Customer.first
        customer.set_default_checked_out

        customer.increase_checked_out_count

        expect(customer.movies_checked_out_count).must_equal 1
      end
    end
  end
end
