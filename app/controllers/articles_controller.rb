class ArticlesController < ApplicationController
  def new
    @article = Article.find_or_initialize params[:url]
    unless @article.save
      render text: "Something went wrong"
    end
  end
end
