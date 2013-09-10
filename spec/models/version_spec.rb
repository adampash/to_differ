require 'spec_helper'

describe Version do
  
  context "validations and associations" do
    
    it {should belong_to :article}
    it {should validate_presence_of :unique_hash}
    
  end
  
  context "#initialize" do
    it "should return a new object with a hash" do
      version = Version.new text: "THIS IS A DUMMY STRING"
      expect(version.unique_hash).to eq '1e8d148d9be57421bc755689952dbbee'
    end
  end
  
  context "#is_new?" do
    it "returns true if version is new" do
      version1 = Version.new text: Factory.version(1)
      version2 = Version.new text: Factory.version(2)
      expect(version1.is_new?(version2.unique_hash)).to eq true
    end
    
    it "returns false if it's the same version of text" do
      version1 = Version.new text: Factory.version(1)
      version2 = Version.new text: Factory.version(1)
      expect(version1.is_new?(version2.unique_hash)).to eq false
    end
  end
end
