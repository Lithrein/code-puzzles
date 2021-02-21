require 'spec_helper'
require_relative '../day07'

instances = [
  { :problem =>
    %q{light red bags contain 1 bright white bag, 2 muted yellow bags.
       dark orange bags contain 3 bright white bags, 4 muted yellow bags.
       bright white bags contain 1 shiny gold bag.
       muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
       shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
       dark olive bags contain 3 faded blue bags, 4 dotted black bags.
       vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
       faded blue bags contain no other bags.
       dotted black bags contain no other bags.},
    :valid_1 => 4,
    :valid_2 => 32,
  } ,
  { :problem =>
    %q{shiny gold bags contain 2 dark red bags.
       dark red bags contain 2 dark orange bags.
       dark orange bags contain 2 dark yellow bags.
       dark yellow bags contain 2 dark green bags.
       dark green bags contain 2 dark blue bags.
       dark blue bags contain 2 dark violet bags.
       dark violet bags contain no other bags.},
    :valid_1 => 0,
    :valid_2 => 126
  }
]

RSpec.describe 'day07_1' do
  instances.each do |inst|
    it "#{inst[:valid_1]} different bags can contain a shiny bag." do
      input = Day07.process_input inst[:problem]
      expect(Day07.part1(input)).to eq(inst[:valid_1])
    end
  end
end

RSpec.describe 'day07_2' do
  instances.each do |inst|
    it "#{inst[:valid_2]} bags are required inside a shiny bag." do
      input = Day07.process_input inst[:problem]
      expect(Day07.part2(input)).to eq(inst[:valid_2])
    end
  end
end
