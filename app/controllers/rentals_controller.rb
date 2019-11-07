RENTAL_KEYS = [:customer_id, :movie_id, :check_out, :due_date]

class RentalsController < ApplicationController
  def check_out
    movie_id = params[:movie_id]
    customer_id = params[:customer_id]
    movie = Movie.find_by(id: movie_id)
    customer = Customer.find_by(id: customer_id)
    
    if movie.nil? || customer.nil?
      render json: {errors: ["Movie or customer can't be nil."]}, status: :bad_request
      return
    end

    # FIX logic to account for no customer
    # if movie.movie_avail? && customer
    if movie.movie_avail? 
      rental = Rental.new(movie_id: params[:movie_id], customer_id: params[:customer_id])
      rental.check_out = Date.today
      rental.set_due_date
    
      if rental.save
        render json: rental.as_json(only: [:id]), status: :ok
        return
      else
        render json: {errors: rental.errors.messages}, status: :bad_request
        return
      end
    else
      render json: {errors: ["no movies currently available."]}, status: :ok
      return
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
