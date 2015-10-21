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

      context "with only the required arguments" do
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
    end

    context "with `pattern`" do
      it "splits on accepts a custom pattern" do
        tokens = Tokeniser.new("We-Are-ALL-in-the-Gutter", pattern: /[^-]+/).tokens
        expect(tokens).to eq(%w[we are all in the gutter])
      end
    end

    context "with `exclude`" do
      context "with `exclude` as a string" do
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

      context "with `exclude` as a regular expression" do
        it "filters on match" do
          tokens = Tokeniser.new("That was magnificent, Trevor.", exclude: /magnificent/i).tokens
          expect(tokens).to eq(%w[that was trevor])
        end
      end

      context "with `exclude` as a lambda" do
        it "calls lambda" do
          tokens = Tokeniser.new("That was magnificent, Trevor.", exclude: ->(token) { token.length < 5 }).tokens
          expect(tokens).to eq(%w[magnificent trevor])
        end
      end

      context "with `exclude` as an array" do
        it "accepts an array of strings" do
          tokens = Tokeniser.new("That was magnificent, Trevor.", exclude: ["magnificent"]).tokens
          expect(tokens).to eq(%w[that was trevor])
        end

        it "accepts an array regular expressions" do
          tokens = Tokeniser.new("That was magnificent, Trevor.", exclude: [/that/, /was/]).tokens
          expect(tokens).to eq(%w[magnificent trevor])
        end

        it "accepts an array of lambdas" do
          filters = [->(token) { token.length < 4}, ->(token) { token.length > 6}]
          tokens = Tokeniser.new("That was magnificent, Trevor.", exclude: filters).tokens
          expect(tokens).to eq(%w[that trevor])
        end

        it "accepts a mixed array" do
          filters = ["that", ->(token) { token.length < 4}, /magnificent/]
          tokens = Tokeniser.new("That was magnificent, Trevor.", exclude: filters).tokens
          expect(tokens).to eq(["trevor"])
        end
      end

      context "with an invalid filter" do
        it "raises an `ArgumentError`" do
          expect { Tokeniser.new("Hello world!", exclude: 1) }.to raise_error(ArgumentError)
        end
      end
    end
  end
end
