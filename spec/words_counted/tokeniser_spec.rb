# -*- coding: utf-8 -*-
require_relative "../spec_helper"

module WordsCounted
  describe Tokeniser do
    describe "initialize" do
      it "sets @input" do
        tokeniser = Tokeniser.new("Hello World!")
        expect(tokeniser.instance_variables).to include(:@input)
      end
    end

    describe "#tokenise" do
      it "normalises tokens and returns an array" do
        tokens = Tokeniser.new("Hello HELLO").tokenise
        expect(tokens).to eq(%w[hello hello])
      end

      context "without arguments" do
        it "removes none alpha-numeric chars" do
          tokens = Tokeniser.new("Hello world! # $ % 12345 * & % ?").tokenise
          expect(tokens).to eq(%w[hello world])
        end

        it "does not split on hyphens" do
          tokens = Tokeniser.new("I am twenty-two.").tokenise
          expect(tokens).to eq(%w[i am twenty-two])
        end

        it "does not split on apostrophe" do
          tokens = Tokeniser.new("Bust 'em! It's Jim's gang.").tokenise
          expect(tokens).to eq(%w[bust 'em it's jim's gang])
        end

        it "does not split on unicode chars" do
          tokens = Tokeniser.new("Bayrūt").tokenise
          expect(tokens).to eq(%w[bayrūt])
        end
      end

      context "with `pattern` options" do
        it "splits on accepts a custom pattern" do
          tokens = Tokeniser.new("We-Are-ALL").tokenise(pattern: /[^-]+/)
          expect(tokens).to eq(%w[we are all])
        end
      end

      context "with `exclude` option" do
        context "as a string" do
          let(:tokeniser) { Tokeniser.new("That was magnificent, Trevor.") }

          it "it accepts a string filter" do
            tokens = tokeniser.tokenise(exclude: "magnificent")
            expect(tokens).to eq(%w[that was trevor])
          end

          it "accepts a string filter with multiple space-delimited tokens" do
            tokens = tokeniser.tokenise(exclude: "was magnificent")
            expect(tokens).to eq(%w[that trevor])
          end

          it "normalises string filter" do
            tokens = tokeniser.tokenise(exclude: "MAGNIFICENT")
            expect(tokens).to eq(%w[that was trevor])
          end
        end

        context "as a regular expression" do
          it "filters on match" do
            tokeniser = Tokeniser.new("That was magnificent, Trevor.")
            tokens = tokeniser.tokenise(exclude: /magnificent/i)
            expect(tokens).to eq(%w[that was trevor])
          end
        end

        context "as a lambda" do
          it "calls lambda" do
            tokeniser = Tokeniser.new("That was magnificent, Trevor.")
            tokens = tokeniser.tokenise(exclude: ->(token) { token.length < 5 })
            expect(tokens).to eq(%w[magnificent trevor])
          end

          it "accepts a symbol for shorthand notation" do
            tokeniser = Tokeniser.new("That was magnificent, محمد.}")
            tokens = tokeniser.tokenise(exclude: :ascii_only?)
            expect(tokens).to eq(%w[محمد])
          end
        end

        context "as an array" do
          let(:tokeniser) { Tokeniser.new("That was magnificent, Trevor.") }

          it "accepts an array of strings" do
            tokens = tokeniser.tokenise(exclude: ["magnificent"])
            expect(tokens).to eq(%w[that was trevor])
          end

          it "accepts an array regular expressions" do
            tokens = tokeniser.tokenise(exclude: [/that/, /was/])
            expect(tokens).to eq(%w[magnificent trevor])
          end

          it "accepts an array of lambdas" do
            filters = [
              ->(token) { token.length < 4 },
              ->(token) { token.length > 6 }
            ]
            tokens = tokeniser.tokenise(exclude: filters)
            expect(tokens).to eq(%w[that trevor])
          end

          it "accepts a mixed array" do
            filters = [
              "that",
              ->(token) { token.length < 4 },
              /magnificent/
            ]
            tokens = tokeniser.tokenise(exclude: filters)
            expect(tokens).to eq(["trevor"])
          end
        end

        context "with an invalid filter" do
          it "raises an `ArgumentError`" do
            expect {
              Tokeniser.new("Hello world!").tokenise(exclude: 1)
            }.to raise_error(ArgumentError)
          end
        end
      end
    end
  end
end
