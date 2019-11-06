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
end
