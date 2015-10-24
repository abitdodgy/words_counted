# -*- coding: utf-8 -*-
require_relative "../spec_helper"

module WordsCounted
  warn "Methods being tested are deprecated"

  describe Counter do
    let(:counter) do
      tokens = WordsCounted::Tokeniser.new("one three three three woot woot").tokenise
      Counter.new(tokens)
    end

    describe "#word_density" do
      it "returns words and their density in percent" do
        expected = [
          ['three', 50.0], ['woot', 33.33], ['one', 16.67]
        ]
        expect(counter.word_density).to eq(expected)
      end

      it "accepts a precision" do
        expected = [
          ['three', 50.0], ['woot', 33.3333], ['one', 16.6667]
        ]
        expect(counter.word_density(4)).to eq(expected)
      end
    end

    describe "#word_occurrences" do
      it "returns a two dimensional array sorted by descending word occurrence" do
        expected = {
          'three' => 3, 'woot' => 2, 'one' => 1
        }
        expect(counter.word_occurrences).to eq(expected)
      end
    end

    describe "#sorted_word_occurrences" do
      it "returns a two dimensional array sorted by descending word occurrence" do
        expected = [
          ['three', 3], ['woot', 2], ['one', 1]
        ]
        expect(counter.sorted_word_occurrences).to eq(expected)
      end
    end

    describe "#word_lengths" do
      it "returns a hash of of words and their length sorted descending by length" do
        expected = {
          'three' => 5, 'woot' => 4, 'one' => 3
        }
        expect(counter.word_lengths).to eq(expected)
      end
    end

    describe "#sorted_word_lengths" do
      it "returns a two dimensional array sorted by descending word length" do
        expected = [
          ['three', 5], ['woot', 4], ['one', 3]
        ]
        expect(counter.sorted_word_lengths).to eq(expected)
      end
    end

    describe "#longest_words" do
      it "returns a two-dimentional array of the longest words and their lengths" do
        expected = [
          ['three', 5]
        ]
        expect(counter.longest_words).to eq(expected)
      end
    end

    describe "#most_occurring_words" do
      it "returns a two-dimentional array of words with the highest frequency and their frequencies" do
        expected = [
          ['three', 3]
        ]
        expect(counter.most_occurring_words).to eq(expected)
      end
    end

    describe "#average_chars_per_word" do
      it "returns the average number of chars per word" do
        expect(counter.average_chars_per_word).to eq(4.33)
      end

      it "accepts precision" do
        expect(counter.average_chars_per_word(4)).to eq(4.3333)
      end
    end

    describe "#count" do
      it "returns count for a single word" do
        expect(counter.count('one')).to eq(1)
      end
    end
  end
end
