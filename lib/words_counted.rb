require "words_counted/version"
require "words_counted/counter"

begin
  require "pry"
rescue LoadError
end

module WordsCounted
  def self.count(string, options = {})
    Counter.new(string, options)
  end

  def self.from_file(path, options = {})
    file = File.open(path)
    data = file.read
    file.close
    count(data, options)
  end
end
