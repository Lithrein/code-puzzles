require 'spec_helper'
require_relative '../day24'

instances = [
  { :problem =>
    %q{sesenwnenenewseeswwswswwnenewsewsw
neeenesenwnwwswnenewnwwsewnenwseswesw
seswneswswsenwwnwse
nwnwneseeswswnenewneswwnewseswneseene
swweswneswnenwsewnwneneseenw
eesenwseswswnenwswnwnwsewwnwsene
sewnenenenesenwsewnenwwwse
wenwwweseeeweswwwnwwe
wsweesenenewnwwnwsenewsenwwsesesenwne
neeswseenwwswnwswswnw
nenwswwsewswnenenewsenwsenwnesesenew
enewnwewneswsewnwswenweswnenwsenwsw
sweneswneswneneenwnewenewwneswswnese
swwesenesewenwneswnwwneseswwne
enesenwswwswneneswsenwnewswseenwsese
wnwnesenesenenwwnenwsewesewsesesew
nenewswnwewswnenesenwnesewesw
eneswnwswnwsenenwnwnwwseeswneewsenese
neswnwewnwnwseenwseesewsenwsweewe
wseweeenwnesenwwwswnew},
    :valid_1 => 10,
    :valid_2 => 2208,
  } ,
]

RSpec.describe 'day24_1' do
  instances.each do |inst|
    it "#{inst[:valid_1]} are left with the black side up." do
      input = inst[:problem].split("\n")
      paths = input.map do |str|
        str.gsub(/(?<!n|s)e/, "nese")
          .gsub(/(?<!n|s)w/, "nwsw")
          .split('')
          .each_slice(2).to_a
          .map(&:join)
      end
      expect(Day24.part1(paths)).to eq(inst[:valid_1])
    end
  end
end

RSpec.describe 'day24_2' do
  instances.each do |inst|
    it "After 100 days, #{inst[:valid_2]} tiles will be left with the black side up." do
      input = inst[:problem].split("\n")
      paths = input.map do |str|
        str.gsub(/(?<!n|s)e/, "nese")
          .gsub(/(?<!n|s)w/, "nwsw")
          .split('')
          .each_slice(2).to_a
          .map(&:join)
      end
      expect(Day24.part2(paths)).to eq(inst[:valid_2])
    end
  end
end
