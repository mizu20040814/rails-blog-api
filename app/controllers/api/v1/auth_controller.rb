class Api::V1::AuthController < ApplicationController
  def login
    if validate_credentials?
      token = gerenate_jwt
      render json: { token: token }
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end

  private

  def validate_credentials?
    params[:email] == ENV["ADMIN_EMAIL"] && params[:password] == ENV["ADMIN_PASSWORD"]
  end

  def gerenate_jwt
    payload = {
      exp: 24.hours.from_now.to_i
    }
    JWT.encode(payload, ENV["JWT_SECRET_KEY"], "HS256")
  end
end
