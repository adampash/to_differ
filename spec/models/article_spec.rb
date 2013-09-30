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

    it "creates a new version only if the text has changed", focus: true do
      url = 'http://blog.adampash.com/2013/09/08/this-is-the-post'
      article = Article.find_or_initialize url
      article.save

      Article.any_instance.stub(:get).and_return(Factory.version 2)
      article1 = Article.find_or_initialize url
      article1.save
      # article.reload
      expect(article1.versions.count).to eq 2
    end

    it "returns a title" do
      pending "needs implimentation"
      url = 'http://blog.adampash.com/2013/09/08/this-is-the-post'
      article = Article.find_or_initialize url
      expect(article.title).to_not be_empty
    end

  end

end
