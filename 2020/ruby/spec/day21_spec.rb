require 'spec_helper'
require_relative '../day21'

instances = [
  { :problem =>
    %q{mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
       trh fvjkl sbzzf mxmxvkd (contains dairy)
       sqjhc fvjkl (contains soy)
       sqjhc mxmxvkd sbzzf (contains fish)},
    :valid_1 => 5,
    :valid_2 => "mxmxvkd,sqjhc,fvjkl",
  } ,
]

RSpec.describe 'day21_1' do
  instances.each do |inst|
    it "Listed ingredients appear a total of #{inst[:valid_2]} times." do
      input = Day21.process_input inst[:problem].split("\n")
      allergenes = Day21.find_allergenes(input)
      expect(Day21.part1(input, allergenes)).to eq(inst[:valid_1])
    end
  end
end

RSpec.describe 'day21_2' do
  instances.each do |inst|
    it "#{inst[:valid_2]} is the canonical list of dangerous ingredients." do
      raw_rules, input = inst[:problem].split("\n\n").map { |x| x.split("\n") }
      input = Day21.process_input inst[:problem].split("\n")
      allergenes = Day21.find_allergenes(input)
      expect(Day21.part2(allergenes)).to eq(inst[:valid_2])
    end
  end
end
