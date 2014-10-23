# -*- coding: utf-8 -*-
require_relative "../spec_helper"

module WordsCounted
  describe Counter do
    let(:counter) { Counter.new("We are all in the gutter, but some of us are looking at the stars.") }

    describe "initialize" do
      it "sets @options" do
        expect(counter.instance_variables).to include(:@options)
      end

      it "sets @char_count" do
        expect(counter.instance_variables).to include(:@char_count)
      end

      it "sets @words" do
        expect(counter.instance_variables).to include(:@words)
      end

      it "sets @word_occurrences" do
        expect(counter.instance_variables).to include(:@word_occurrences)
      end

      it "sets @word_lengths" do
        expect(counter.instance_variables).to include(:@word_lengths)
      end
    end

    describe "words" do
      it "returns an array" do
        expect(counter.words).to be_a(Array)
      end

      it "splits words" do
        expect(counter.words).to eq(%w[We are all in the gutter but some of us are looking at the stars])
      end

      it "removes special characters" do
        counter = Counter.new("Hello! # $ % 12345 * & % How do you do?")
        expect(counter.words).to eq(%w[Hello How do you do])
      end

      it "counts hyphenated words as one" do
        counter = Counter.new("I am twenty-two.")
        expect(counter.words).to eq(%w[I am twenty-two])
      end

      it "does not split words on apostrophe" do
        counter = Counter.new("Bust 'em! Them be Jim's bastards'.")
        expect(counter.words).to eq(%w[Bust 'em Them be Jim's bastards'])
      end

      it "does not split on unicode chars" do
        counter = Counter.new("São Paulo")
        expect(counter.words).to eq(%w[São Paulo])
      end

      it "it accepts a string filter" do
        counter = Counter.new("That was magnificent, Trevor.", exclude: "magnificent")
        expect(counter.words).to eq(%w[That was Trevor])
      end

      it "it accepts a string filter with multiple words" do
        counter = Counter.new("That was magnificent, Trevor.", exclude: "was magnificent")
        expect(counter.words).to eq(%w[That Trevor])
      end

      it "filters words in uppercase when using a string filter" do
        counter = Counter.new("That was magnificent, Trevor.", exclude: "Magnificent")
        expect(counter.words).to eq(%w[That was Trevor])
      end

      it "accepts a regexp filter" do
        counter = Counter.new("That was magnificent, Trevor.", exclude: /magnificent/i)
        expect(counter.words).to eq(%w[That was Trevor])
      end

      it "accepts an array filter" do
        counter = Counter.new("That was magnificent, Trevor.", exclude: ['That', 'was'])
        expect(counter.words).to eq(%w[magnificent Trevor])
      end

      it "accepts a lambda filter" do
        counter = Counter.new("That was magnificent, Trevor.", exclude: ->(w) {w == 'That'})
        expect(counter.words).to eq(%w[was magnificent Trevor])
      end

      it "accepts a custom regexp" do
        counter = Counter.new("I am 007.", regexp: /[\p{Alnum}\-']+/)
        expect(counter.words).to eq(["I", "am", "007"])
      end

      it "char_count should be calculated after the filter is applied" do
        counter = Counter.new("I am Legend.", exclude: "I am")
        expect(counter.char_count).to eq(6)
      end
    end

    describe "word_count" do
      it "returns the correct word count" do
        expect(counter.word_count).to eq(15)
      end
    end

    describe "word_occurrences" do
      it "returns a hash" do
        expect(counter.word_occurrences).to be_a(Hash)
      end

      it "treats capitalized words as the same word" do
        counter = Counter.new("Bad, bad, piggy!")
        expect(counter.word_occurrences).to eq({ "bad" => 2, "piggy" => 1 })
      end
    end

    describe "most_occurring_words" do
      it "returns an array" do
        expect(counter.most_occurring_words).to be_a(Array)
      end

      it "returns highest occuring words" do
        counter = Counter.new("Orange orange Apple apple banana")
        expect(counter.most_occurring_words).to eq([["orange", 2],["apple", 2]])
      end
    end

    describe 'word_lengths' do
      it "returns a hash" do
        expect(counter.word_lengths).to be_a(Hash)
      end

      it "returns a hash of word lengths" do
        counter = Counter.new("One two three.")
        expect(counter.word_lengths).to eq({ "One" => 3, "two" => 3, "three" => 5 })
      end
    end

    describe "longest_words" do
      it "returns an array" do
        expect(counter.longest_words).to be_a(Array)
      end

      it "returns the longest words" do
        counter = Counter.new("Those whom the gods love grow young.")
        expect(counter.longest_words).to eq([["Those", 5],["young", 5]])
      end
    end

    describe "word_density" do
      it "returns an array" do
        expect(counter.word_density).to be_a(Array)
      end

      it "returns words and their density in percent" do
        counter = Counter.new("His name was major, I mean, Major Major Major Major.")
        expect(counter.word_density).to eq([["major", 50.0], ["mean", 10.0], ["i", 10.0], ["was", 10.0], ["name", 10.0], ["his", 10.0]])
      end
    end

    describe "char_count" do
      it "returns the number of chars in the passed in string" do
        counter = Counter.new("His name was major, Major Major Major Major.")
        expect(counter.char_count).to eq(35)
      end

      it "returns the number of chars in the passed in string after the filter is applied" do
        counter = Counter.new("His name was major, Major Major Major Major.", exclude: "Major")
        expect(counter.char_count).to eq(10)
      end
    end

    describe "average_chars_per_word" do
      it "returns the average number of chars per word" do
        counter = Counter.new("His name was major, Major Major Major Major.")
        expect(counter.average_chars_per_word).to eq(4)
      end

      it "returns the average number of chars per word after the filter is applied" do
        counter = Counter.new("His name was major, Major Major Major Major.", exclude: "Major")
        expect(counter.average_chars_per_word).to eq(3)
      end
    end

    describe "unique_word_count" do
      it "returns the number of unique words" do
        expect(counter.unique_word_count).to eq(13)
      end
    end
  end

  describe "from_file" do
    it "opens and reads a text file" do
      counter = WordsCounted.from_file('spec/support/the_hart_and_the_hunter.txt')
      expect(counter.word_count).to eq(139)
    end
  end
end
