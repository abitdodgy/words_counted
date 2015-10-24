# -*- coding: utf-8 -*-
require_relative "../spec_helper"

module WordsCounted
  describe Counter do
    let(:counter) do
      tokens = WordsCounted::Tokeniser.new("one three three three woot woot").tokenise
      Counter.new(tokens)
    end

    describe "initialize" do
      it "sets @tokens" do
        expect(counter.instance_variables).to include(:@tokens)
      end
    end

    describe "#token_count" do
      it "returns the correct number of tokens" do
        expect(counter.token_count).to eq(6)
      end
    end

    describe "#uniq_token_count" do
      it "returns the number of unique token" do
        expect(counter.uniq_token_count).to eq(3)
      end
    end

    describe "#char_count" do
      it "returns the correct number of chars" do
        expect(counter.char_count).to eq(26)
      end
    end

    describe "#token_frequency" do
      it "returns a two-dimensional array where each member array is a token and its frequency in descending order" do
        expected = [
          ['three', 3], ['woot', 2], ['one', 1]
        ]
        expect(counter.token_frequency).to eq(expected)
      end
    end

    describe "#token_lengths" do
      it "returns a two-dimensional array where each member array is a token and its length in descending order" do
        expected = [
          ['three', 5], ['woot', 4], ['one', 3]
        ]
        expect(counter.token_lengths).to eq(expected)
      end
    end

    describe "#token_density" do
      it "returns a two-dimensional array where each member array is a token and its density in descending order" do
        expected = [
          ['three', 0.5], ['woot', 0.33], ['one', 0.17]
        ]
        expect(counter.token_density).to eq(expected)
      end

      it "accepts a precision" do
        expected = [
          ['three', 0.5], ['woot', 0.3333], ['one', 0.1667]
        ]
        expect(counter.token_density(precision: 4)).to eq(expected)
      end
    end

    describe "#most_frequent_tokens" do
      it "returns a hash of the tokens with the highest frequency, where each key a token, and each value is its frequency" do
        expected = {
          'three' => 3
        }
        expect(counter.most_frequent_tokens).to eq(expected)
      end
    end

    describe "#longest_tokens" do
      it "returns a hash of the tokens with the highest length, where each key a token, and each value is its length" do
        expected = {
          'three' => 5
        }
        expect(counter.longest_tokens).to eq(expected)
      end
    end
  end
end
