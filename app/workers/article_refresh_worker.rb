class ArticleRefreshWorker
  include Sidekiq::Worker

  def perform
    Article.needs_refresh.each do |article|
      puts "checking for #{article.id}"
      Article.fetch_new_version article.id
      puts "Check again at #{article.reload.check_at}"
    end
  end
end
