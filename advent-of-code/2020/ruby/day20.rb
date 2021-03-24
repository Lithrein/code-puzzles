#! /usr/bin/env ruby

module Day20
  extend self

  def find_nessy image, i
    nessy1 = /(?=(..................#.))/
    nessy2 = /(?=(#....##....##....###))/
    nessy3 = /(?=(.#..#..#..#..#..#...))/

    pos1 = image[i+0].enum_for(:scan, nessy1).map { Regexp.last_match.begin(0) }
    pos2 = image[i+1].enum_for(:scan, nessy2).map { Regexp.last_match.begin(0) }
    pos3 = image[i+2].enum_for(:scan, nessy3).map { Regexp.last_match.begin(0) }

    pos1 & pos2 & pos3
  end

  def compute_sides pic
    [
      pic[0],                     # top
      pic.map { |r| r[-1] }.join, # rigth
      pic[-1],                    # bottom
      pic.map { |r| r[0] }.join   # left
    ]
  end

  def print_map map
    map.each do |r|
      puts r.join " "
    end
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
    neighbors = neighbors.map { |h,vs| [h, vs.flatten] }.to_h
  end

  def build_map neighbors, sides
    sz = Math.sqrt neighbors.keys.length.to_i
    map = Array.new(sz) { Array.new(sz) }

    # choose the first tile
    neighbors.select {|h,vs| vs.length == 2}
    map[0][0] = neighbors.select {|h,vs| vs.length == 2}.map {|h,vs| h}.first
    neighbors.keys.each do |k|
      neighbors[k] -= [map[0][0]]
    end

    (1..sz-1).each do |i|
      (1..i-1).each do |j|
        map[j][i - j] = (neighbors[map[j][i-j-1]] & neighbors[map[j-1][i-j]]).first
        neighbors.keys.each do |k|
          neighbors[k] -= [map[j][i-j]]
        end
      end
      map[0][i] = neighbors[map[0][i-1]].first
      neighbors.keys.each do |k|
        neighbors[k] -= [map[0][i]]
      end
      map[i][0] = neighbors[map[i-1][0]].first
      neighbors.keys.each do |k|
        neighbors[k] -= [map[i][0]]
      end
    end
    (1..sz-1).each do |i|
      ((sz-i).to_i..(sz-1)).each do |j|
        map[i][j] = (neighbors[map[i-1][j]] & neighbors[map[i][j-1]]).first
        neighbors.keys.each do |k|
          neighbors[k] -= [map[i][j]]
        end
      end
    end
    map
  end

  def rotate_tile tile
    tile.map.with_index do |row,i|
      row1 = row.split('')
      row1.map.with_index do |col,j|
        tile[j][tile.length - i - 1]
      end.join
    end
  end

  def flip_tile_vert tile
    tile.map { |r| r.reverse }
  end

  def flip_tile_horiz tile
    len = tile.length
    tile.map.with_index { |r,idx| tile[len - idx - 1] }
  end

  def generate_image tiles, tile_map
    # todo: fix the orientation of the first tile
    # currently does not support the example because of this.
    image = Array.new(tile_map.length) { Array.new(tile_map.length) }

    tile_map.length.times do |i|
      tile_map.length.times do |j|
        # find the most recent closest neighbor (the right tile if it exists or
        # the tile just above)
        neighbor = j == 0 ? (i == 0 ? [] : [i-1,0]) : [i,j-1]
        current_tile = tiles[tile_map[i][j]]

        if !neighbor.empty? then
          if i - 1 == neighbor[0] then # match bot/top
            bot = compute_sides(tiles[tile_map[neighbor[0]][neighbor[1]]])[2]

            top = compute_sides(current_tile)[0]
            while top != bot && top.reverse != bot do
              current_tile = rotate_tile(current_tile)
              top = compute_sides(current_tile)[0]
            end
            if top.reverse == bot then
              current_tile = flip_tile_vert(current_tile)
            end
          else # match right/left
            right = compute_sides(tiles[tile_map[neighbor[0]][neighbor[1]]])[1]

            left = compute_sides(current_tile)[3]
            while left != right && left.reverse != right do
              current_tile = rotate_tile(current_tile)
              left = compute_sides(current_tile)[3]
            end
            if left.reverse == right then
              current_tile = flip_tile_horiz(current_tile)
            end
          end
        end
        image[i][j] = current_tile
        tiles[tile_map[i][j]] = current_tile
      end
    end
    image
  end

  def pretty_print_image image
    image.each do |tiles|
      10.times do |i|
        puts tiles.map { |ri| ri[i] }.join " "
      end
      puts ""
    end
  end

  def print_image image
    res = []
    image.each do |tiles|
      8.times do |i|
        res += [(tiles.map { |ri| ri[i+1][1..8] }).join]
      end
    end
    res
  end


  @transfos = {
    0 => ->x{x},                                       # id
    1 => ->x{flip_tile_vert(x)},                       # s
    2 => ->x{rotate_tile(x)},                          # r
    3 => ->x{rotate_tile(@transfos[2].call(x))},       # rr
    4 => ->x{rotate_tile(@transfos[3].call(x))},       # rrr
    5 => ->x{@transfos[1].call(@transfos[1].call(x))}, # s r
    6 => ->x{@transfos[1].call(@transfos[2].call(x))}, # s rr
    7 => ->x{@transfos[1].call(@transfos[4].call(x))}, # s rrr
  }

  def part1 neighbors
    neighbors.map { |h,vs| vs.length == 2 ? h.to_i : 1 }.reduce :*
  end

  def part2 neighbors, input_tiles, input_sides
    tile_map = build_map(neighbors, input_sides)
    @transfos.each do |_,f|
      res = 0
      image = f.call(print_image(generate_image(input_tiles, tile_map)))
      94.times do |i|
        res += find_nessy(image,i).length
      end
      return image.join.count('#') - res*15 if res != 0
    end
  end
end

if $0 == __FILE__ then
  input = File.open('../inputs/day20').read

  input_tiles = input.split("\n\n").map do |entry|
    grid = entry.split("\n")
    nb = grid[0].match(/Tile (\d+):/)[1]
    [nb, grid[1..-1]]
  end.to_h

  input_sides = input.split("\n\n").map do |entry|
    grid = entry.split("\n")
    nb = grid[0].match(/Tile (\d+):/)[1]
    [nb, Day20.compute_sides(grid[1..-1])]
  end.to_h

  neighbors = Day20.find_neighbors(input_sides)
  puts Day20.part1 neighbors
  puts Day20.part2 neighbors, input_tiles, input_sides
end
