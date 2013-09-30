require 'open-uri'

class Article < ActiveRecord::Base
  validates :url, uniqueness: true
  
  has_many :versions
  
  class << self
    def find_or_initialize url
      article = Article.find_or_initialize_by url: url
      text = article.fetch
      version = Version.new(text: text)
      article.versions << version unless article.version_already_exists?(version)
      article
    end
  end
  
  def fetch
    source = get url
    content = Readability::Document.new(source, {remove_empty_nodes: true, tags: %w(p div a)}).content
    # p 'fetchin'
    content
  end
  
  def text
    versions.first.text unless versions.empty?
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
    open(url).read
  end
end
