require "test_helper"

describe CustomersController do
  describe "index" do
    it "responds with JSON and success" do
      get customers_path

      expect(response.header['Content-Type']).must_include 'json'
      must_respond_with :ok
    end

    it "responds with an array of customer hashes" do
      get customers_path

      body = JSON.parse(response.body)

      expect(body).must_be_instance_of Array
      body.each do |customer|
        expect(customer).must_be_instance_of Hash
        expect(customer.keys.sort).must_equal ["id", "movies_checked_out_count", "name", "phone", "postal_code", "registered_at"]
      end
    end

    it "will respond with an empty array when there are no customers" do
      Rental.destroy_all
      Customer.destroy_all
  
      get customers_path
      body = JSON.parse(response.body)
  
      expect(body).must_be_instance_of Array
      expect(body).must_equal []
    end

  end



end
