require 'spec_helper'
require_relative '../day01'

nums_ok = [
  [1721, 979, 366, 299, 675, 1456],
  [1,2017,3,2]
].map &:sort

nums_ko = [
  [2020,2019],
  [1760,349,37,270]
].map &:sort

RSpec.describe 'part1' do
  nums_ok.each do |num|
    it "assert that the list `#{num}` contains 2 numbers which sum is 2020" do
      res = part1(num,2020).sum
      expect(res).to eq(2020)
    end
  end

  nums_ko.each do |num|
    it "assert that the list `#{num}` does not contain 2 numbers which sum is 2020" do
      res = part1(num,2020).sum
      expect(res).to eq(0)
    end
  end
end

RSpec.describe 'part2' do
  nums_ok.each do |num|
    it "assert that the list `#{num}` contains 3 numbers which sum is 2020" do
      res = part2(num,2020).sum
      expect(res).to eq(2020)
    end
  end

  nums_ko.each do |num|
    it "assert that the list `#{num}` does not contain 3 numbers which sum is 2020" do
      res = part2(num,2020).sum
      expect(res).to eq(0)
    end
  end
end
