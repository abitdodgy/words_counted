# -*- coding: utf-8 -*-
require_relative "../spec_helper"

module WordsCounted
  describe Counter do
    let(:counter) do
      tokens = WordsCounted::Tokeniser.new("We are all in the gutter, but some of us are looking at the stars.").tokenise
      Counter.new(tokens)
    end

    describe "initialize" do
      it "sets @tokens" do
        expect(counter.instance_variables).to include(:@tokens)
      end
    end

    describe "#token_count" do
      it "returns the correct number of tokens" do
        expect(counter.token_count).to eq(15)
      end
    end

    describe "#uniq_token_count" do
      it "returns the number of unique token" do
        expect(counter.uniq_token_count).to eq(13)
      end
    end

    describe "#char_count" do
      it "returns the correct number of chars" do
        expect(counter.char_count).to eq(50)
      end
    end

    describe "#token_frequency" do
      it "returns a two-dimensional array where each member array is a token and its frequency in descending order" do
        expected = [
          ['are', 2], ['the', 2], ['but', 1], ['us', 1], ['of', 1], ['some', 1], ['looking', 1],
          ['gutter', 1], ['at', 1], ['in', 1], ['all', 1], ['stars', 1], ['we', 1]
        ]
        expect(counter.token_frequency).to eq(expected)
      end
    end

    describe "#token_lengths" do
      it "returns a two-dimensional array where each member array is a token and its length in descending order" do
        expected = [
          ['looking', 7], ['gutter', 6], ['stars', 5], ['some', 4], ['but', 3], ['the', 3],
          ['are', 3], ['all', 3], ['us', 2], ['in', 2], ['at', 2], ['of', 2], ['we', 2]
        ]
        expect(counter.token_lengths).to eq(expected)
      end
    end

    describe "#token_density" do
      it "returns a two-dimensional array where each member array is a token and its density in descending order" do
        expected = [
          ['are', 0.13], ['the', 0.13], ['looking', 0.07], ['in', 0.07], ['at', 0.07],['gutter', 0.07],
          ['all', 0.07], ['some', 0.07], ['of', 0.07], ['us', 0.07], ['but', 0.07], ['stars', 0.07], ['we', 0.07]
        ]
        expect(counter.token_density).to eq(expected)
      end

      it "accepts a precision" do
        expected = [
          ['are', 0.1333], ['the', 0.1333], ['looking', 0.0667], ['in', 0.0667], ['at', 0.0667], ['gutter', 0.0667],
          ['all', 0.0667], ['some', 0.0667], ['of', 0.0667], ['us', 0.0667], ['but', 0.0667], ['stars', 0.0667], ['we', 0.0667]
        ]
        expect(counter.token_density(precision: 4)).to eq(expected)
      end
    end

    describe "#most_frequent_tokens" do
      it "returns a hash of the tokens with the highest frequency, where each key a token, and each value is its frequency" do
        expected = {
          'are' => 2,
          'the' => 2
        }
        expect(counter.most_frequent_tokens).to eq(expected)
      end
    end

    describe "#longest_tokens" do
      it "returns a hash of the tokens with the highest length, where each key a token, and each value is its length" do
        expected = {
          'looking' => 7
        }
        expect(counter.longest_tokens).to eq(expected)
      end
    end
  end
end
