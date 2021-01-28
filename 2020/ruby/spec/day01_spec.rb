require 'spec_helper'
require_relative '../day01'

nums = [
  [1721, 979, 366, 299, 675, 1456].sort
]

RSpec.describe 'part1' do
  nums.each do |num|
    it "assert that the list `#{num}` contains 2 numbers which sum is 2020" do
      res = part1(num,2020).sum
      expect(res).to eq(2020)
    end
  end
end

RSpec.describe 'part2' do
  nums.each do |num|
    it "assert that the list `#{num}` contains 3 numbers which sum is 2020" do
      res = part2(num,2020).sum
      expect(res).to eq(2020)
    end
  end
end
