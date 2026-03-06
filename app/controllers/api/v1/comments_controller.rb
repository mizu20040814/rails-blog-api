class Api::V1::CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_article, only: [:index, :create]
  before_action :set_comment, only: [:destroy]

  # GET /api/v1/articles/:article_id/comments
  def index
    @comments = @article.comments.includes(:user).order(created_at: :desc)
    render json: @comments.map { |c| comment_response(c) }  
  end

  # POST /api/v1/articles/:article_id/comments
  def create
    @comment = @article.comments.build(comment_params)
    @comment.user = @current_user

    if @comment.save
      render json: comment_response(@comment), status: :created
    else
      render json: { errors: @comment.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/comments/:id
  def destroy
    if @comment.user_id == @current_user.id
      @comment.destroy
      head :no_content
    else
      render json: { error: "Forbidden" }, status: :forbidden
    end
  end

  private
  
  def set_article
    @article = Article.find(params[:article_id])
  end

  def set_comment
    @comment = Comment.find_by(params[:id])
  end

  def comment_params
    params.permit(:body)
  end

  def authenticate_user!
    token = request.headers["Authorization"]&.split(" ")&.last
    begin
      decorded = JWT.decode(token, ENV["JWT_SECRET_KEY"], true, algorithm:"HS256")
      @current_user = User.find(decorded[0]["user_id"])
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  def comment_response(comment)
    {
      id: comment.id,
      body: comment.body,
      user: {
        id: comment.user.id,
        name: comment.user.name
      },
      created_at: comment.created_at
    }
  end
    
end
