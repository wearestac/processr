$:.unshift File.dirname(__FILE__)

class Processr
  
  class << self
    def root=(path); @root = path; end
    def root; @root; end
    
    def out=(path); @out = path; end
    def out; @out; end
    
    def configure(&block)
      yield self
    end
  end
  
  attr_accessor :buffer, :files, :filters
  
  def initialize
    self.buffer  = ""
    self.files   = []
    self.filters = []
  end
  
  def add_filter(filter)
    self.filters << filter
  end
  
  def process!
    read_files
    process_filters
    write_output
  end
  
  def <<(text)
    self.buffer << text
  end
  
  private
  def read_files
    self.files.each do |file|
      read_file_to_buffer(file)
    end
  end
  
  def read_file_to_buffer(file)
    self.buffer << File.open(File.join(self.class.root, file)).read
  end
  
  def process_filters
    self.filters.each do |filter|
      self.buffer = filter.call(self.buffer)
    end
  end
  
  def write_output
    self.class.out.nil? ? self.buffer : write_buffer_file
  end
  
  def write_buffer_file
    output_file = File.open(self.class.out, "w+")
    output_file.puts self.buffer
    output_file.close
    
    true
  end
end
