require "./test/test_helper"

describe RentalsController do

  describe "check_out" do
    before do
      @customer = Customer.first
      @movie = Movie.first
    end

    it "responds with JSON and success" do
      rental_data = {
        customer_id: @customer.id,
        movie_id: @movie.id
      }

      expect {
        post rentals_check_out_path, params: rental_data
      }.must_differ "Rental.count", 1

      body = JSON.parse(response.body)

      must_respond_with :ok
      expect(response.header['Content-Type']).must_include 'json'
      expect(body.keys).must_include "id"
      expect(Rental.last.movie).must_equal @movie
      expect(Rental.last.check_out).must_equal Date.today
      expect(Rental.last.due_date).must_equal (Date.today + 7)
    end

    it "will respond with an error message and not create the rental if no movies are available" do
      @movie.available_inventory = 0
      @movie.save

      rental_data = {
        customer_id: @customer.id,
        movie_id: @movie.id
      }
  
      expect {
        post rentals_check_out_path, params: rental_data
      }.wont_differ "Rental.count"

      body = JSON.parse(response.body)

      must_respond_with :ok
      expect(response.header['Content-Type']).must_include 'json'
      expect(body["errors"]).must_equal ["no movies currently available."]
    end

    it "will update the available_inventory" do
      rental_data = {
        customer_id: @customer.id,
        movie_id: @movie.id
      }

      post rentals_check_out_path, params: rental_data

      expect(Movie.find_by(id: @movie.id).available_inventory).must_equal (Movie.find_by(id: @movie.id).inventory - 1)
    end

    it "will respond with bad_request for invalid data" do
      rental_data = {
        customer_id: @customer_id
      }

      expect {
        post rentals_check_out_path, params: rental_data
      }.wont_differ "Rental.count"

      body = JSON.parse(response.body)

      must_respond_with :bad_request
      expect(response.header['Content-Type']).must_include 'json'
      expect(body["errors"]).must_equal ["Movie or customer can't be nil."] 
    end

  end

  describe "check_in" do
    before do
      @customer = Customer.first
      @movie = Movie.first
    end

    it "responds with JSON and success" do
      rental_data = {
        customer_id: @customer.id,
        movie_id: @movie.id
      }

      post rentals_check_out_path, params: rental_data
      post rentals_check_in_path, params: rental_data

      body = JSON.parse(response.body)

      must_respond_with :ok
      expect(response.header['Content-Type']).must_include 'json'
      expect(body.keys).must_include "id"
      expect(Rental.last.movie).must_equal @movie
      expect(Rental.last.check_out).must_equal Date.today
      expect(Rental.last.due_date).must_equal (Date.today + 7)
      expect(Rental.last.check_in).must_equal Date.today
    end

    it "will update the available_inventory plus 1" do
      rental_data = {
        customer_id: @customer.id,
        movie_id: @movie.id
      }

      post rentals_check_out_path, params: rental_data
      post rentals_check_in_path, params: rental_data

      expect(Movie.find_by(id: @movie.id).available_inventory).must_equal (Movie.find_by(id: @movie.id).inventory)
    end

    it "will respond with bad_request for invalid data" do
      rental_data = {
        customer_id: @customer_id
      }

      expect {
        post rentals_check_in_path, params: rental_data
      }.wont_differ "Rental.count"

      body = JSON.parse(response.body)

      must_respond_with :bad_request
      expect(response.header['Content-Type']).must_include 'json'
      expect(body["errors"]).must_equal ["Movie or customer can't be nil."] 
    end

  end
end
