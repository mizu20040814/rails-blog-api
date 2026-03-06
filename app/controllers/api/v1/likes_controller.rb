class Api::V1::LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment

  # POST: /api/v1/comments/:comment_id/like
  def create
    @like = @comment.likes.build(user: @current_user)
    if @like.save
      render json: { liked: true, likes_count: @comment.likes.count }, status: :created
    else
      render json: { errors: "Already liked" }, status: :unprocessable_entity
    end
  end

  # DELETE: /api/v1/comments/:comment_id/like
  def destroy
    @like = @comment.likes.find_by(user: @current_user)
    if @like
      @like.destroy
      render json: { liked: false, likes_count: @comment.likes.count }
    else
      render json: { errors: "Not liked yet" }, status: :not_found
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def authenticate_user!
    token = request.headers["Authorization"]&.split(" ")&.last
    begin
      decorded = JWT.decode(token, ENV["JWT_SECRET_KEY"], true, algorithm: "HS256")
      @current_user = User.find(decorded[0]["user_id"])
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end
