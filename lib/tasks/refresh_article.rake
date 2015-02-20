desc "Refresh existing articles"

task :refresh_articles => :environment do
  puts "Refreshing articles"
  ArticleRefreshWorker.new.perform
  puts "Done"
end
