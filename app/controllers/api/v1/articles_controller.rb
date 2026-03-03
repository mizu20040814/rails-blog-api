class Api::V1::ArticlesController < ApplicationController
  # *NOTE: 公開済の記事の一覧と詳細を返すAPI
  # *NOTE: 認証は不要

  # GET /api/v1/articles
  def index
    @articles = Article.published
    render json: @articles
  end

  # GET /api/v1/articles/:id
  def show
    @article = Article.published.find(params[:id])
    render json: @article
  end
end
