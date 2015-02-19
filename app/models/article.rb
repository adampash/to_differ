require 'httparty'
TXT_FETCH_API = "http://text-fetch.herokuapp.com"

class Article < ActiveRecord::Base
  validates :url, uniqueness: true

  has_many :versions

  class << self
    def find_or_initialize url
      article = Article.find_or_initialize_by url: url

      if article.new_record?
        save_version = true
      else
        hash = article.get_latest_hash
        save_version = article.latest_version.is_new?(hash)
      end
      if save_version
        content = JSON.parse article.fetch
        version = Version.new(
                    text: content["text"]["markdown"],
                    title: content["title"],
                    unique_hash: content["hash"]
                  )

        article.versions << version unless article.version_already_exists?(version)
      end
      article
    end
  end

  def fetch
    HTTParty.post TXT_FETCH_API, {body: {format: 'markdown', url: url}}
  end

  def get_latest_hash
    JSON.parse(
      HTTParty.post "#{TXT_FETCH_API}/check", {body: {url: url}}
    )["hash"]
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
