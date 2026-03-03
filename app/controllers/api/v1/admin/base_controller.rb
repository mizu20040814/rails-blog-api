class Api::V1::Admin::BaseController < ApplicationController
  # !NOTE:共通処理はここに書く
  before_action :authenticate!

  private

  def authenticate!
    # 認証のロジックをここに実装する
    # 例: トークンの検証、ユーザーの認証など
    token = request.headers["Authorization"]&.split(" ")&.last
    begin
      JWT.decode(token, ENV["JWT_SECRET_KEY"], true, algorithm: "HS256")
    rescue JWT::DecodeError
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end
