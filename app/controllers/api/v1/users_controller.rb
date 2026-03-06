class Api::V1::UsersController < ApplicationController
  # POST /api/v1/users/register
  def register
    @user = User.new(user_params)
    if @user.save
      token = generate_jwt(@user)
      render json: { user: user_response(@user), token: token }, status: :created
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/users/login
  def login
    @user = User.find_by(email: params[:email])

    if @user&.authenticate(params[:password])
      token = generate_jwt(@user)
      render json: { user: user_response(@user), token: token }
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password)
  end

  def generate_jwt(user)
    payload = {
      user_id: user.id,
      exp: 24.hours.from_now.to_i
    }
    JWT.encode(payload, ENV["JWT_SECRET_KEY"], "HS256")
  end

  def user_response(user)
    {
      id: user.id,
      name: user.name,
      email: user.email
    }
  end
end
