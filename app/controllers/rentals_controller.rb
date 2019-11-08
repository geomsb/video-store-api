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

    if movie.movie_avail? 
      rental = Rental.new(movie_id: movie_id, customer_id: customer_id)
      rental.check_out = Date.today
      rental.set_due_date
      movie.reduce_avail_inv
      customer.check_out_movie
    
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
    customer_id = params[:customer_id]
    movie = Movie.find_by(id: movie_id)
    customer = Customer.find_by(id: customer_id)
    
    if movie.nil? || customer.nil?
      render json: {errors: ["Movie or customer can't be nil."]}, status: :bad_request
      return
    end

    rental = customer.rentals.find_by(movie_id: movie_id, check_in: nil) 
    rental.check_in = Date.today
    movie.increase_avail_inv
    customer.check_in_movie
  
    if rental.save
      render json: rental.as_json(only: [:id]), status: :ok
      return
    else
      render json: {errors: rental.errors.messages}, status: :bad_request
      return
    end
  end

  private

  def rental_params
    params.permit(RENTAL_KEYS)
  end
end
