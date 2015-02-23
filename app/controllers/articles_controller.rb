class ArticlesController < ApplicationController
  protect_from_forgery except: :post

  def index
    @articles = Article.order(updated_at: :desc)
  end

  def show
    @article = Article.find_or_initialize params[:url]
    unless @article.save
      render text: "Something went wrong"
    end
  end

  def create
    @article = Article.find_or_initialize params[:url]
    if @article.save
      render json: {success: true}
    else
      render json: {success: false}
    end
  end
end
