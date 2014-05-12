module WordsCounted
  class Counter
    attr_reader :words, :word_occurrences, :word_lengths, :char_count

    WORD_REGEX = /[\p{Alpha}\-']+/

    def initialize(string, options = {})
      @options = options
      @char_count = string.length
      @filter = filter_proc(options[:filter])
      @words = string.scan(regex).reject { |word| @filter.call(word) }
      @word_occurrences = words.each_with_object(Hash.new(0)) do |word, hash|
        hash[word.downcase] += 1
      end
      @word_lengths = words.each_with_object({}) { |word, hash| hash[word] ||= word.length }
    end

    def word_count
      words.size
    end

    def unique_word_count
      words.uniq.size
    end

    def average_chars_per_word
      (char_count / word_count).round(2)
    end

    def most_occurring_words
      highest_ranking word_occurrences
    end

    def longest_words
      highest_ranking word_lengths
    end

    def word_density
      word_occurrences.each_with_object({}) do |(word, occ), hash|
        hash[word] = percent_of(occ)
      end.sort_by { |_, value| value }.reverse
    end

    private

    def highest_ranking(entries)
      entries.group_by { |word, value| value }.sort.last.last
    end

    def percent_of(n)
      (n.to_f / word_count.to_f * 100.0).round(2)
    end

    def regex
      @options[:regex] || WORD_REGEX
    end

    def filter_proc(filter)
      if filter.respond_to?(:to_a)
        filter_procs = Array(filter).map(&method(:filter_proc))
        ->(word) {
          filter_procs.any? { |p| p.call(word) }
        }
      elsif filter.respond_to?(:to_str)
        f = filter.split.collect { |word| word.downcase }
        ->(w) { f.include?(w.downcase) }
      elsif Regexp.try_convert(filter)
        filter = Regexp.try_convert(filter)
        Proc.new { |w| w =~ filter }
      elsif filter.respond_to?(:to_proc)
        filter.to_proc
      else
        raise ArgumentError, "Incorrect filter type"
      end
    end

  end
end
