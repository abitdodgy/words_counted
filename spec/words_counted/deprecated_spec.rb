# -*- coding: utf-8 -*-
require_relative "../spec_helper"

module WordsCounted
  warn "Methods being tested are deprecated"

  describe Counter do
    let(:counter) do
      tokens = WordsCounted::Tokeniser.new("We are all in the gutter, but some of us are looking at the stars.").tokenise
      Counter.new(tokens)
    end

    describe "#word_density" do
      it "returns words and their density in percent" do
        expected = [
          ['are', 13.33], ['the', 13.33], ['looking', 6.67], ['in', 6.67], ['at', 6.67], ['gutter', 6.67],
          ['all', 6.67], ['some', 6.67], ['of', 6.67], ['us', 6.67], ['but', 6.67], ['stars', 6.67], ['we', 6.67]
        ]
        expect(counter.word_density).to eq(expected)
      end

      it "accepts a precision" do
        expected = [
          ['are', 13.3333], ['the', 13.3333], ['looking', 6.6667], ['in', 6.6667], ['at', 6.6667], ['gutter', 6.6667],
          ['all', 6.6667], ['some', 6.6667], ['of', 6.6667], ['us', 6.6667], ['but', 6.6667], ['stars', 6.6667], ['we', 6.6667]
        ]
        expect(counter.word_density(4)).to eq(expected)
      end
    end

    describe "#word_occurrences" do
      it "returns a two dimensional array sorted by descending word occurrence" do
        expected = {
          'are' => 2, 'the' => 2, 'but' => 1, 'us' => 1, 'of' => 1, 'some' => 1, 'looking' => 1,
          'gutter' => 1, 'at' => 1, 'in' => 1, 'all' => 1, 'stars' => 1, 'we' => 1
        }
        expect(counter.word_occurrences).to eq(expected)
      end
    end

    describe "#sorted_word_occurrences" do
      it "returns a two dimensional array sorted by descending word occurrence" do
        expected = [
          ['are', 2], ['the', 2], ['but', 1], ['us', 1], ['of', 1], ['some', 1],
          ['looking', 1], ['gutter', 1], ['at', 1], ['in', 1], ['all', 1], ['stars', 1], ['we', 1]
        ]
        expect(counter.sorted_word_occurrences).to eq(expected)
      end
    end

    describe "#word_lengths" do
      it "returns a two dimensional array sorted by descending word length" do
        expected = {
          'looking' => 7, 'gutter' => 6, 'stars' => 5, 'some' => 4, 'but' => 3, 'the' => 3,
          'are' => 3, 'all' => 3, 'us' => 2, 'in' => 2, 'at' => 2, 'of' => 2, 'we' => 2
        }
        expect(counter.word_lengths).to eq(expected)
      end
    end

    describe "#sorted_word_lengths" do
      it "returns a two dimensional array sorted by descending word length" do
        expected = [
          ['looking', 7], ['gutter', 6], ['stars', 5], ['some', 4], ['but', 3],
          ['the', 3], ['are', 3], ['all', 3], ['us', 2], ['in', 2], ['at', 2], ['of', 2], ['we', 2]
        ]
        expect(counter.sorted_word_lengths).to eq(expected)
      end
    end

    describe "#longest_words" do
      it "returns the longest words" do
        expected = [
          ['looking', 7]
        ]
        expect(counter.longest_words).to eq(expected)
      end
    end

    describe "#most_occurring_words" do
      it "returns the longest words" do
        expected = [
          ['are', 2],
          ['the', 2]
        ]
        expect(counter.most_occurring_words).to eq(expected)
      end
    end

    describe "#average_chars_per_word" do
      it "returns the average number of chars per word" do
        expect(counter.average_chars_per_word).to eq(3.33)
      end

      it "accepts precision" do
        expect(counter.average_chars_per_word(4)).to eq(3.3333)
      end
    end

    describe "#count" do
      it "returns count for a single word" do
        expect(counter.count('are')).to eq(2)
      end
    end
  end
end
