require 'spec_helper'
require_relative '../day02'

instances = [
  { :problem => [
       "1-3 a: abcde",
       "1-3 b: cdefg",
       "2-9 c: ccccccccc"
    ],
    :sol1 => 2,
    :sol2 => 1
  }
]

RSpec.describe 'day02_1' do
  instances.each do |inst|
    it "assert that #{inst[:sol1]} passwds are okay (policy 1) in the list `#{inst[:problem]}` ?" do
      input = inst[:problem].map &Day02.method(:process_input)
      expect(Day02.part1(input)).to eq(inst[:sol1])
    end
  end
end

RSpec.describe 'day02_2' do
  instances.each do |inst|
    it "assert that #{inst[:sol2]} passwds are okay (policy 2) in the list `#{inst[:problem]}` ?" do
      input = inst[:problem].map &Day02.method(:process_input)
      expect(Day02.part2(input)).to eq(inst[:sol2])
    end
  end
end
