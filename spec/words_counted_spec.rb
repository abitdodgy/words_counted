# -*- coding: utf-8 -*-
require_relative "spec_helper"

describe WordsCounted do
  describe ".from_file" do
    it "opens and reads a text file" do
      counter = WordsCounted.from_file('spec/support/the_hart_and_the_hunter.txt')
      expect(counter.token_count).to eq(139)
    end

    it "opens and reads a text file with options" do
      counter = WordsCounted.from_file('spec/support/the_hart_and_the_hunter.txt', exclude: 'hunter')
      expect(counter.token_count).to eq(135)
    end
  end
end
