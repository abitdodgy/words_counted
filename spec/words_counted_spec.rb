# -*- coding: utf-8 -*-
require_relative "spec_helper"

describe WordsCounted do
  describe ".from_file" do
    let(:file_path) { "spec/support/the_hart_and_the_hunter.txt" }

    it "opens and reads a text file" do
      counter = WordsCounted.from_file(file_path)
      expect(counter.token_count).to eq(139)
    end

    it "opens and reads a text file with options" do
      counter = WordsCounted.from_file(file_path, exclude: "hunter")
      expect(counter.token_count).to eq(135)
    end
  end

  describe ".count" do
    let(:string) do
      "We are all in the gutter, but some of us are looking at the stars."
    end

    it "returns a counter instance with given input as tokens" do
      counter = WordsCounted.count(string)
      expect(counter.token_count).to eq(15)
    end

    it "returns a counter instance with given input and options" do
      counter = WordsCounted.count(string, exclude: "the gutter")
      expect(counter.token_count).to eq(12)
    end
  end
end
