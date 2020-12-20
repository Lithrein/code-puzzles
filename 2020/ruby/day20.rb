#! /usr/bin/env ruby

def compute_sides pic
  [
    pic[0],                     # top
    pic.map { |r| r[-1] }.join, # rigth
    pic[-1],                    # bottom
    pic.map { |r| r[0] }.join   # left
  ]
end


def find_neighbors input
  input = input.map { |h,v| [h,v] }
  sz = Math.sqrt(input.length).to_i
  neighbors = Hash.new []
  neighbors_oriented = Hash.new []

  input.length.times do |i|
    nb    = input[i][0]
    sides = input[i][1]
    sides.each do |s|
      current_tab = input - [input[i]]
      a = current_tab.map do |h,v|
        [h, v.index(s) || v.index(s.reverse)]
      end.select do |h, idx|
        idx != nil
      end.map do |h,v|
        h
      end
      neighbors[nb] += [a]
    end
  end
  neighbors = neighbors.map { |h,vs| [h, vs.map(&->v{ v[0] })] }.to_h
end


input_tiles = File.open('../inputs/day20').read.split("\n\n").map do |entry|
  grid = entry.split("\n")
  nb = grid[0].match(/Tile (\d+):/)[1]
  [nb, grid[1..-1]]
end.to_h

input_sides = File.open('../inputs/day20').read.split("\n\n").map do |entry|
  grid = entry.split("\n")
  nb = grid[0].match(/Tile (\d+):/)[1]
  [nb, compute_sides(grid[1..-1])]
end.to_h

neighbors = find_neighbors(input_sides)

puts neighbors.map { |h,vs| vs.select { |v| !v.nil? }.length == 2 ? h.to_i : 1 }.reduce :*
