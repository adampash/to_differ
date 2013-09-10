# override network access and return sample data
require_relative 'factory'

def stub_network version=2
  html = Factory.version 1
  html2 = Factory.version version
  Article.any_instance.stub(:get).and_return(html, html2)
end