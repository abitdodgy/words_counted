# -*- coding: utf-8 -*-
require_relative "../spec_helper"

module WordsCounted
  describe Tokeniser do
    describe "initialize" do
      it "sets @tokens" do
        tokeniser = Tokeniser.new("We are all in the gutter, but some of us are looking at the stars.")
        expect(tokeniser.instance_variables).to include(:@tokens)
      end

      it "normalises tokens" do
        tokens = Tokeniser.new("We Are ALL in the Gutter").tokens
        expect(tokens).to eq(%w[we are all in the gutter])
      end
    end

    describe "#tokens" do
      context "without additional arguments" do
        it "returns an array or normalised tokens" do
          tokens = Tokeniser.new("We are all in the gutter, but some of us are looking at the stars.").tokens
          expect(tokens).to eq(%w[we are all in the gutter but some of us are looking at the stars])
        end

        it "removes none alpha-numeric chars" do
          tokens = Tokeniser.new("Hello! # $ % 12345 * & % How do you do?").tokens
          expect(tokens).to eq(%w[hello how do you do])
        end

        it "does not split on hyphens" do
          tokens = Tokeniser.new("I am twenty-two.").tokens
          expect(tokens).to eq(%w[i am twenty-two])
        end

        it "does not split on apostrophe" do
          tokens = Tokeniser.new("Bust 'em! Them be Jim's bastards'.").tokens
          expect(tokens).to eq(%w[bust 'em them be jim's bastards'])
        end

        it "does not split on unicode chars" do
          tokens = Tokeniser.new("Bayrūt").tokens
          expect(tokens).to eq(%w[bayrūt])
        end
      end

      context "with :exclude as a string" do
        it "it accepts a string filter" do
          tokens = Tokeniser.new("That was magnificent, Trevor.", exclude: "magnificent").tokens
          expect(tokens).to eq(%w[that was trevor])
        end

        it "it accepts a string filter with multiple space-delimited tokens" do
          tokens = Tokeniser.new("That was magnificent, Trevor.", exclude: "was magnificent").tokens
          expect(tokens).to eq(%w[that trevor])
        end

        it "normalises string filter" do
          tokens = Tokeniser.new("That was magnificent, Trevor.", exclude: "MAGNIFICENT").tokens
          expect(tokens).to eq(%w[that was trevor])
        end
      end
    end
  end
end
