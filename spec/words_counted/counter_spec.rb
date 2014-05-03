require "spec_helper"

module WordsCounted
  describe Counter do
    let(:counter) { Counter.new("We are all in the gutter, but some of us are looking at the stars.") }

    describe "#initialize" do
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

    describe ".words" do
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

      it "filters words" do
        counter = Counter.new("That was magnificent, Trevor.", filter: "magnificent")
        expect(counter.words).to eq(%w[That was Trevor])
      end

      it "splits words based on regex" do
        counter = Counter.new("I am 007.", regex: /[\p{Alnum}\-']+/)
        expect(counter.words).to eq(["I", "am", "007"])
      end
    end

    describe ".word_count" do
      it "returns the correct word count" do
        expect(counter.word_count).to eq(15)
      end
    end

    describe ".word_occurrences" do
      it "returns a hash" do
        expect(counter.word_occurrences).to be_a(Hash)
      end

      it "treats capitalized words as the same word" do
        counter = Counter.new("Bad, bad, piggy!")
        expect(counter.word_occurrences).to eq({ "bad" => 2, "piggy" => 1 })
      end
    end

    describe ".most_occurring_words" do
      it "returns an array" do
        expect(counter.most_occurring_words).to be_a(Array)
      end

      it "returns highest occuring words" do
        counter = Counter.new("Orange orange Apple apple banana")
        expect(counter.most_occurring_words).to eq([["orange", 2],["apple", 2]])
      end
    end

    describe '.word_lengths' do
      it "returns a hash" do
        expect(counter.word_lengths).to be_a(Hash)
      end

      it "returns a hash of word lengths" do
        counter = Counter.new("One two three.")
        expect(counter.word_lengths).to eq({ "One" => 3, "two" => 3, "three" => 5 })
      end
    end

    describe ".longest_words" do
      it "returns an array" do
        expect(counter.longest_words).to be_a(Array)
      end

      it "returns the longest words" do
        counter = Counter.new("Those whom the gods love grow young.")
        expect(counter.longest_words).to eq([["Those", 5],["young", 5]])
      end
    end

    describe ".word_density" do
      it "returns a hash" do
        expect(counter.word_density).to be_a(Array)
      end

      it "returns words and their density in percent" do
        counter = Counter.new("His name was major, I mean, Major Major Major Major.")
        expect(counter.word_density).to eq([["major", 50.0], ["mean", 10.0], ["i", 10.0], ["was", 10.0], ["name", 10.0], ["his", 10.0]])
      end
    end

    describe ".char_count" do
      it "returns the number of chars in the passed in string" do
        expect(counter.char_count).to eq(66)
      end
    end

    describe ".average_chars_per_word" do
      it "returns the average number of chars per word" do
        expect(counter.average_chars_per_word).to eq(4)
      end
    end
  end
end
