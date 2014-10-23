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
end
