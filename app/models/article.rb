require 'httparty'
TXT_FETCH_API = "http://text-fetch.herokuapp.com"

class Article < ActiveRecord::Base
  validates :url, uniqueness: true

  has_many :versions

  class << self
    def find_or_initialize url
      article = Article.find_or_initialize_by url: url

      if article.new_record?
        article.save
        article.update_attribute('check_at', article.created_at + 1.minute)
        Article.fetch_new_version article.id
      end
      article
    end

    def fetch_new_version(article_id)
      article = Article.find article_id
      content = article.fetch
      if article.version_already_exists?(content["md5"])
        article.set_next_check
      else
        version = Version.new(
                    text: content["text"],
                    title: content["title"],
                    unique_hash: content["md5"]
                  )

        article.versions << version
        article.update_attribute('check_at', article.updated_at + 1.minute)
      end
    end

    def needs_refresh
      where('check_at < ?', Time.now)
    end
  end

  def set_next_check
    new_check = Time.now + (Time.now - latest_version.created_at)*2
    new_check = [new_check, Time.now + 2.days].min
    update_attribute('check_at', new_check)
  end

  def fetch
    params = {body:
      {
        format: 'markdown',
        url: url,
      }
    }
    params[:body][:md5] = md5 unless md5.nil?
    HTTParty.post TXT_FETCH_API, params
  end

  def md5
    latest_version.unique_hash unless versions.length == 0
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

  def version_already_exists? unique_hash
    if versions.count == 0
      false
    else
      versions.where(unique_hash: unique_hash).count > 0
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
