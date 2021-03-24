require 'spec_helper'
require_relative '../day17'

instances = [
  { :problem => [
      [ '.', '#', '.' ],
      [ '.', '.', '#' ],
      [ '#', '#', '#' ]
    ],
    :valid_1 => 112,
    :valid_2 => 848,
  } ,
]

RSpec.describe 'day17_1' do
  instances.each do |inst|
    it "After the 3rd dimensional full six boot process, " + \
       "#{inst[:valid_1]} cubes are in the active state." do
      input = inst[:problem]
      expect(Day17.part1(input,6)).to eq(inst[:valid_1])
    end
  end
end

RSpec.describe 'day17_2' do
  instances.each do |inst|
    it "After the 3rd dimensional full six boot process, " + \
       "#{inst[:valid_2]} cubes are in the active state." do
      input = inst[:problem]
      expect(Day17.part2(input,6)).to eq(inst[:valid_2])
    end
  end
end
