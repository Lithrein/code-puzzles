require 'spec_helper'
require_relative '../day09'

instances = [
  { :problem => [35, 20, 15, 25, 47, 40, 62, 55, 65, 95, 102, 117, 150, 182, 127, 219, 299, 277, 309, 576],
    :preamble_size => 6,
    :valid_1 => 127,
    :valid_2 => 62,
  } ,
]

RSpec.describe 'day09_1' do
  instances.each do |inst|
    it "#{inst[:valid_1]} different bags can contain a shiny bag." do
      input = inst[:problem]
      expect(Day09.part1(input, inst[:preamble_size])).to eq(inst[:valid_1])
    end
  end
end

RSpec.describe 'day09_2' do
  instances.each do |inst|
    it "#{inst[:valid_2]} bags are required inside a shiny bag." do
      input = inst[:problem]
      expect(Day09.part2(input, inst[:preamble_size])).to eq(inst[:valid_2])
    end
  end
end
