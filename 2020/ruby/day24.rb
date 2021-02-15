#! /usr/bin/env ruby

module Day24
  extend self

def walk path
  x, y = 0, 0
  path.each do |c|
    case c
    when 'ne' then
      y += 1
    when 'nw' then
      x += 1
    when 'se' then
      x -= 1
    when 'sw' then
      y -= 1
    end
  end
  [x,y]
end

def walk_and_flip paths
  marked = Hash.new 0
  paths.each do |path|
    pos = walk(path)
    marked[pos] += 1
  end
  marked.select { |h,v| v % 2 == 1 }
end

# neighbors of (0,0):
#   - (0,1), (0,-1), (-1,1)
#   - (1,0), (-1,0), (1,-1)
#   - (1,1), (-1,-1) not neighbors
#   - neighbors |(x-x0) + (y-y0)| < 2
#       e == nese == sene
#       w == nwsw == swnw
def neighbors pos
  x0, y0 = pos
  rel_neighbors = [[0,1], [0,-1], [-1,1], [1,0], [-1,0], [1,-1]]

  rel_neighbors.map { |(x,y)| [x + x0, y + y0] }
end

def next_config config
  to_be_flipped = []

  # black to flip
  config.each do |h,v|
    nb_black_neighbors = neighbors(h).select { |n| config[n] == 1 }.length
    if nb_black_neighbors == 0 || nb_black_neighbors > 2 then
      to_be_flipped << h
    end
  end

  # white to flip
  config.keys.permutation(2).each do |t1, t2|
    candidates = neighbors(t1) & neighbors(t2)
    candidates.each do |h|
      if config[h] != 1 && neighbors(h).select { |n| config[n] == 1 }.length == 2 then
        to_be_flipped << h
      end
    end
  end

  to_be_flipped.uniq!

  # flip time
  to_be_flipped.each do |h|
    config[h] = config[h].nil? ? 1 : config[h] + 1
  end

  # only keep blacks
  config.select { |h,v| v % 2 == 1 }
end

def next_config_n config, n
  new_config = config
  i = 0
  while i < n do
    p i
    new_config = next_config(new_config)
    i += 1
  end
  new_config
end
def part1 paths
  walk_and_flip(paths).length
end

# todo: speed up this
def part2 paths
  end_config  = next_config_n(walk_and_flip(paths), 100).length
end
end

if $0 == __FILE__ then
input = <<-DATA
sesenwnenenewseeswwswswwnenewsewsw
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
wseweeenwnesenwwwswnew
DATA
  .split "\n"
input = File.open('../inputs/day24').read.lines.map(&:chomp)

paths = input.map do |str|
  str.gsub(/(?<!n|s)e/, "nese")
     .gsub(/(?<!n|s)w/, "nwsw")
     .split('')
     .each_slice(2).to_a
     .map(&:join)
end

puts "Part 1: #{Day24.part1 paths}"
puts "Part 2: #{Day24.part2 paths}"
end
