class ArticlesController < ApplicationController

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
    unless @article.save
      render text: "Something went wrong"
    end
  end
end
