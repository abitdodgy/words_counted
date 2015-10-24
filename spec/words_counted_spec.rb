# -*- coding: utf-8 -*-
require_relative "spec_helper"

describe WordsCounted do
  describe ".from_file" do
    it "opens and reads a text file" do
      counter = WordsCounted.from_file("spec/support/the_hart_and_the_hunter.txt")
      expect(counter.token_count).to eq(139)
    end

    it "opens and reads a text file with options" do
      counter = WordsCounted.from_file("spec/support/the_hart_and_the_hunter.txt", exclude: "hunter")
      expect(counter.token_count).to eq(135)
    end
  end

  describe ".count" do
    it "returns a counter instance with given input as tokens" do
      counter = WordsCounted.count("We are all in the gutter, but some of us are looking at the stars.")
      expect(counter.token_count).to eq(15)
    end

    it "returns a counter instance with given input and options" do
      counter = WordsCounted.count("We are all in the gutter!", exclude: "the gutter")
      expect(counter.tokens).to eq(%w[we are all in])
    end
  end
end
