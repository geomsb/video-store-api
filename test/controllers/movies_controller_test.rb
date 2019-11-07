require "test_helper"

describe MoviesController do
  describe "index" do
    it "responds with JSON and success" do
      get movies_path

      expect(response.header['Content-Type']).must_include 'json'
      must_respond_with :ok
    end

    it "responds with an array of movies hashes" do
      get movies_path

      body = JSON.parse(response.body)

      expect(body).must_be_instance_of Array
      body.each do |movie|
        expect(movie).must_be_instance_of Hash
        expect(movie.keys.sort).must_equal ["id", "release_date", "title"]
      end
    end

    it "will respond with an empty array when there are no movies" do
      Rental.destroy_all
      Movie.destroy_all
  
      get movies_path
      body = JSON.parse(response.body)
  
      expect(body).must_be_instance_of Array
      expect(body).must_equal []
    end
  end

  describe "show" do
    before do
      @movie = movies(:old_movie)
    end

    it "responds with JSON and success" do
      get movie_path(@movie.id)

      expect(response.header['Content-Type']).must_include 'json'
      must_respond_with :ok
    end

    it "must respond with a hash of a movie" do
      get movie_path(@movie.id)

      body = JSON.parse(response.body)
      expect(body).must_be_instance_of Hash
      expect(body.keys.sort).must_equal ["available_inventory", "id", "inventory", "overview", "release_date", "title"]
      expect(body["title"]).must_equal @movie.title
    end

    it "should respond with 'not found' if given an invalid id" do
      id = -1
      get movie_path(id)

      body = JSON.parse(response.body)

      expect(body).must_be_instance_of Hash
      must_respond_with :not_found
      expect(body.keys.sort).must_equal ["errors"]
      expect(body["errors"]).must_equal ["Movie #{id} not found"]
    end
  end

  describe "create" do
    before do
      @movie_data = {
        title: "Test movie",
        overview: "bad movie",
        release_date: "2019-11-06",
        inventory: 4
      }
    end
    it "responds with created status when request is valid" do
      expect {
        post movies_path, params: @movie_data
      }.must_differ 'Movie.count', 1

      body = JSON.parse(response.body)
      must_respond_with :ok
      expect(body.keys).must_include "id"
      expect(Movie.last.title).must_equal @movie_data[:title]
      expect(Movie.last.available_inventory).must_equal @movie_data[:inventory]
    end

    it "will respond with bad_request for invalid data" do
      @movie_data[:title] = nil
    
      expect {
        post movies_path, params: @movie_data
      }.wont_change "Movie.count"
    
      must_respond_with :bad_request
    
      expect(response.header['Content-Type']).must_include 'json'
      body = JSON.parse(response.body)
      expect(body["errors"].keys).must_include "title"
    end
  end
end
