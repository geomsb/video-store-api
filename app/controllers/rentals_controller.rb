RENTAL_KEYS = [:customer_id, :movie_id]

class RentalsController < ApplicationController
  def check_out
    movie_id = rental_params[:movie_id]
    movie = Movie.find_by(id: movie_id)
    if movie.check_out
      rental = Rental.new(rental_params)
      rental.check_out = Date.today
      rental.due_date = rental.check_out + 7
      if rental.save
        render json: rental.as_json(only: [:id]), status: :ok
        return
      else
        render json: {errors: rental.errors.messages}, status: :bad_request
        return
      end
    else
      render json: {"errors" => ["no movies currently available."]}, status: :ok
    end
  end

  def check_in 
    movie_id = params[:movie_id]
    movie = Movie.find_by(id: movie_id)
    movie.check_in
  end

  private

  def rental_params
    params.permit(RENTAL_KEYS)
  end
end
