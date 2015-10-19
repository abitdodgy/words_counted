# -*- encoding : utf-8 -*-
module WordsCounted
  class Tokeniser
    attr_reader :tokens

    TOKEN_REGEXP = /[\p{Alpha}\-']+/

    def initialize(input, pattern: TOKEN_REGEXP, exclude: nil)
      filter_proc = filter_as_proc(exclude)
      @tokens = input.scan(pattern).map(&:downcase).reject { |token| filter_proc.call(token) }
    end

  private

    def filter_as_proc(filter)
      if filter.respond_to?(:to_str)
        normalized_exclusion_list = filter.split.map(&:downcase)
        ->(token) {
          normalized_exclusion_list.include?(token)
        }
      else
        ->(token) { false }
      end
    end
  end
end
