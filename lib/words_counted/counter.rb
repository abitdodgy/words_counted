module WordsCounted
  class Counter
    attr_reader :words

    WORD_REGEX = /[^\p{Alpha}\-']+/

    def initialize(string, filter = "")
      @words = string.split(WORD_REGEX).reject { |word| filter.split.include? word.downcase }
    end

    def count
      words.size
    end

    def word_occurrences
      @occurrences ||= words.each_with_object(Hash.new(0)) { |word, result| result[word.downcase] += 1 }
    end

    def word_lengths
      @lengths ||= words.each_with_object({}) { |word, result| result[word] ||= word.length }
    end

    def most_occurring_words
      highest_ranking word_occurrences
    end

    def longest_words
      highest_ranking word_lengths
    end

    private

    def highest_ranking(entries)
      entries.group_by { |word, occurrence| occurrence }.sort.last.last
    end
  end
end
