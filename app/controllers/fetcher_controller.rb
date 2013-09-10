require 'open-uri'
class FetcherController < ApplicationController
  def new
    source = open(params[:url]).read
    content = Readability::Document.new(source, {remove_empty_nodes: true}).content
    logger.debug "CONTENT: " + content
    render text: content
  end
end
