require 'spec_helper'
require_relative '../day13'

instances = [
  { :problem => ["939", "7,13,x,x,59,x,31,19"],
    :valid_1 => 295,
    :valid_2 => 1068781,
  }
]

RSpec.describe 'day13_1' do
  instances.each do |inst|
    it "The id of the earliest bus you can take to the airport" + \
       "multiplied by the number of minutes you'll need to wait is #{inst[:valid_1]}" do
      input = inst[:problem]
      expect(Day13.part1(input)).to eq(inst[:valid_1])
    end
  end
end

RSpec.describe 'day13_2' do
  instances.each do |inst|
    it "The earliest timestamp such that all of the listed bus IDs" + \
       "depart at offsets matching their positions in the list is #{inst[:valid_2]}" do
      input = inst[:problem]
      expect(Day13.part2(input)).to eq(inst[:valid_2])
    end
  end
end
