class ArticlesController < ApplicationController
  # GET /articles
  def index
    @articles = Article.all
    render json: @articles
  end

  # GET /articles/:id
  def show
    @article = Article.find(params[:id])
    render json: @article
  end

  # POST /articles
  def create
    @article = Article.new(article_params)
    if @article.save
      render json: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  # PUT /articles/:id
  def update
    @article = Article.find(params[:id])
    if @article.update(article_params)
      render json: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  # DELETE /articles/:id
  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    head :no_content
  end

  private

  def article_params
    params.require(:article).permit(:title, :content)
  end
end
