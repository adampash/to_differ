require 'spec_helper'

describe Article do
  it { should validate_uniqueness_of(:url) }

  it { should have_many(:versions) }

  context "#fetch" do

    before(:each) do
      stub_network
    end

    it "returns text from a url" do
      url = 'http://blog.adampash.com/2013/09/08/this-is-the-post'
      article = Article.find_or_initialize url
      expect(article.text).to_not be_empty
    end

    it "does not create a new version if the text is identical" do
      url = 'http://blog.adampash.com/2013/09/08/this-is-the-post'
      article = Article.find_or_initialize url
      article.save
      article1 = Article.find_or_initialize url
      article1.save
      expect(article.versions.count).to eq 1
    end

    xit "creates a new version only if the text has changed" do
      url = 'http://blog.adampash.com/2013/09/08/this-is-the-post'
      article = Article.find_or_initialize url
      article.save

      Article.any_instance.stub(:get).and_return(Factory.version 2)
      article1 = Article.find_or_initialize url
      Article.fetch_new_version article1.id
      expect(article1.versions.count).to eq 2
    end

    it "returns a title" do
      url = 'http://blog.adampash.com/2013/09/08/this-is-the-post'
      article = Article.find_or_initialize url
      expect(article.title).to_not be_empty
    end

    it "sets the check at time to double time since last new version" do
      url = 'http://blog.adampash.com/2013/09/08/this-is-the-post'
      article = Article.find_or_initialize url
      expect(article.check_at).to eq (article.created_at + 1.minute)

      current_time = Time.now
      article.latest_version.update_attribute('created_at', current_time - 10.minutes)
      article.set_next_check
      expect(article.check_at.round).to eq (current_time.utc + 20.minutes).round
    end

    it "maxes out the check_at time at 2 days" do
      url = 'http://blog.adampash.com/2013/09/08/this-is-the-post'
      article = Article.find_or_initialize url
      expect(article.check_at).to eq (article.created_at + 1.minute)

      current_time = Time.now
      article.latest_version.update_attribute('created_at', current_time - 4.days)
      article.set_next_check
      expect(article.check_at.round).to eq (current_time.utc + 2.days).round
    end

    it "returns a group of articles that need updated" do
      url = 'http://blog.adampash.com/2013/09/08/this-is-the-post'
      article = Article.find_or_initialize url

      expect(Article.needs_refresh.length).to eq 0

      article.update_attribute('check_at', Time.now - 1.minute)
      expect(Article.needs_refresh.length).to eq 1

      article.update_attribute('check_at', Time.now + 1.minute)
      expect(Article.needs_refresh.length).to eq 0
    end

  end

end
