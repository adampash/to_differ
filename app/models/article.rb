require 'open-uri'

class Article < ActiveRecord::Base
  validates :url, uniqueness: true

  has_many :versions

  class << self
    def find_or_initialize url
      article = Article.find_or_initialize_by url: url
      content = article.fetch
      version = Version.new(text: content[:text], title: content[:title])
      article.versions << version unless article.version_already_exists?(version)
      article
    end
  end

  def fetch
    source = get url
    article = Readability::Document.new(
      source,
      {
        remove_empty_nodes: true,
        tags: %w(p div a img ul ol li blockquote),
        :attributes => %w[src href]
      }
    )
    text = ReverseMarkdown.convert("<h2>#{article.title}</h2>" + article.content)
    content = {text: text, title: article.title}
  end

  def text
    versions.first.text unless versions.empty?
  end

  def title
    versions.last.title
  end

  def latest_version
    versions.last
  end

  def first_version
    versions.first
  end

  def version_already_exists? version
    if versions.count == 0
      false
    else
      versions.where(unique_hash: version.unique_hash).count > 0
    end
  end

  private

  def get url
    # open(url).read
    agent = Mechanize.new
    page = agent.get url
    page.content
  end
end
