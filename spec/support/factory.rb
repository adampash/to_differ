module Factory

  class << self
  
    def version num
      File.read(File.join('spec', 'fixtures', "version#{num}.html"))
    end
  
  end
  
end