require "spec_helper"

module WordsCounted
  describe Counter do

    describe ".words" do
      let(:counter) { Counter.new("We are all in the gutter, but some of us are looking at the stars.") }

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
        counter = Counter.new("That was magnificent, Trevor.", "magnificent")
        expect(counter.words).to eq(%w[That was Trevor])
      end
    end

    describe ".word_count" do
      let(:counter) { Counter.new("In that case I'll take measures to secure you, woman!") }

      it "returns the correct word count" do
        expect(counter.word_count).to eq(10)
      end
    end

    describe ".word_occurrences" do
      let(:counter) { Counter.new("Bad, bad, piggy!") }

      it "returns a hash" do
        expect(counter.word_occurrences).to be_a(Hash)
      end

      it "treats capitalized words as the same word" do
        expect(counter.word_occurrences).to eq({ "bad" => 2, "piggy" => 1 })
      end
    end

    describe ".most_occurring_words" do
      let(:counter) { Counter.new("One should always be in love. That is the reason one should never marry.") }

      it "returns an array" do
        expect(counter.most_occurring_words).to be_a(Array)
      end

      it "returns highest occuring words" do
        expect(counter.most_occurring_words).to eq([["one", 2],["should", 2]])
      end
    end

    describe '.word_lengths' do
      let(:counter) { Counter.new("One two three.") }

      it "returns a hash" do
        expect(counter.word_lengths).to be_a(Hash)
      end

      it "returns a hash of word lengths" do
        expect(counter.word_lengths).to eq({ "One" => 3, "two" => 3, "three" => 5 })
      end
    end

    describe ".longest_words" do
      let(:counter) { Counter.new("Those whom the gods love grow young.") }

      it "returns an array" do
        expect(counter.longest_words).to be_a(Array)
      end

      it "returns the longest words" do
        expect(counter.longest_words).to eq([["Those", 5],["young", 5]])
      end
    end
  end
end
