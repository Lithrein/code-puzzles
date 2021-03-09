require 'spec_helper'
require_relative '../day20'

instances = [
  { :problem =>
    %q{Tile 2311:
       ..##.#..#.
       ##..#.....
       #...##..#.
       ####.#...#
       ##.##.###.
       ##...#.###
       .#.#.#..##
       ..#....#..
       ###...#.#.
       ..###..###

       Tile 1951:
       #.##...##.
       #.####...#
       .....#..##
       #...######
       .##.#....#
       .###.#####
       ###.##.##.
       .###....#.
       ..#.#..#.#
       #...##.#..

       Tile 1171:
       ####...##.
       #..##.#..#
       ##.#..#.#.
       .###.####.
       ..###.####
       .##....##.
       .#...####.
       #.##.####.
       ####..#...
       .....##...

       Tile 1427:
       ###.##.#..
       .#..#.##..
       .#.##.#..#
       #.#.#.##.#
       ....#...##
       ...##..##.
       ...#.#####
       .#.####.#.
       ..#..###.#
       ..##.#..#.

       Tile 1489:
       ##.#.#....
       ..##...#..
       .##..##...
       ..#...#...
       #####...#.
       #..#.#.#.#
       ...#.#.#..
       ##.#...##.
       ..##.##.##
       ###.##.#..

       Tile 2473:
       #....####.
       #..#.##...
       #.##..#...
       ######.#.#
       .#...#.#.#
       .#########
       .###.#..#.
       ########.#
       ##...##.#.
       ..###.#.#.

       Tile 2971:
       ..#.#....#
       #...###...
       #.#.###...
       ##.##..#..
       .#####..##
       .#..####.#
       #..#.#..#.
       ..####.###
       ..#.#.###.
       ...#.#.#.#

       Tile 2729:
       ...#.#.#.#
       ####.#....
       ..#.#.....
       ....#..#.#
       .##..##.#.
       .#.####...
       ####.#.#..
       ##.####...
       ##..#.##..
       #.##...##.

       Tile 3079:
       #.#.#####.
       .#..######
       ..#.......
       ######....
       ####.#..#.
       .#...#.##.
       #.#####.##
       ..#.###...
       ..#.......
       ..#.###...},
    :valid_1 => 20899048083289,
    :valid_2 => 2,
  } ,
]

RSpec.describe 'day20_1' do
  instances.each do |inst|
    it "The labels of the corner-tiles multiplied together gives #{inst[:valid_2]}." do
      input_tiles = inst[:problem].split("\n\n").map do |entry|
        grid = entry.split("\n")
        nb = grid[0].match(/Tile (\d+):/)[1]
        [nb, grid[1..-1].map(&:strip)]
      end.to_h

      input_sides = inst[:problem].split("\n\n").map do |entry|
        grid = entry.split("\n")
        nb = grid[0].match(/Tile (\d+):/)[1]
        [nb, Day20.compute_sides(grid[1..-1].map(&:strip))]
      end.to_h

      neighbors = Day20.find_neighbors(input_sides)
      expect(Day20.part1(neighbors)).to eq(inst[:valid_1])
    end
  end
end

# RSpec.describe 'day20_2' do
#   instances.each do |inst|
#     it "#{inst[:valid_2]} '#' are part of a sea monster." do
#       input_tiles = inst[:problem].split("\n\n").map do |entry|
#         grid = entry.split("\n")
#         nb = grid[0].match(/Tile (\d+):/)[1]
#         [nb, grid[1..-1].map(&:strip)]
#       end.to_h

#       input_sides = inst[:problem].split("\n\n").map do |entry|
#         grid = entry.split("\n")
#         nb = grid[0].match(/Tile (\d+):/)[1]
#         [nb, Day20.compute_sides(grid[1..-1].map(&:strip))]
#       end.to_h

#       neighbors = Day20.find_neighbors(input_sides)
#       expect(Day20.part2(neighbors, input_tiles, input_sides)).to eq(inst[:valid_2])
#     end
#   end
# end
