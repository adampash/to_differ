require 'digest/md5'

class Version < ActiveRecord::Base
  belongs_to :article

  validates :unique_hash, presence: true

  class << self

  end


  def is_new? hash
    unique_hash != hash
  end

  private
  def generate_hash
    if self.text.nil?
      self.unique_hash = 'NO TEXT'
    else
      self.unique_hash = Digest::MD5.hexdigest self.text
    end
  end

end
