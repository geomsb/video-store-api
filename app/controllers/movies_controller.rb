KEYS = [:id, :title, :overview, :release_date, :inventory, :available_inventory]

class MoviesController < ApplicationController
  def index
    movies = Movie.all
    render json: movies.as_json(only: [:id, :release_date, :title]), status: :ok
  end

  def show
    movie = Movie.find_by(id: params[:id]).as_json(only: KEYS)

    if movie
      render json: movie, status: :ok
    else
      render json: {"errors" => ["Movie #{params[:id]} not found"]}, status: :not_found
    end
  end

  private

  def movie_params
    params.require(:movie).permit(KEYS)
  end
end
