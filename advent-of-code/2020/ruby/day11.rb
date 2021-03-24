#! /usr/bin/env ruby

input = File.open('../inputs/day11').readlines.map(&:chop)
$height = input.length
$width  = input[0].length

def get input, i, j
  0 <= i && i < $height && 0 <= j && j < $width ? input[i][j] : 'L'
end

def becomes_occupied input, i, j
  get(input,i,j) == 'L' &&
  [[0,1], [1,0], [-1, 0], [0, -1], [-1,1], [-1,-1],[1,-1],[1,1]].all? do |di, dj|
    di1 = di
    dj1 = dj
    # seat = get(input,i+di1,j+dj1)
    # while seat == '.' do
    #   di1 += di
    #   dj1 += dj
    #   seat = get(input,i+di1,j+dj1)
    # end
    get(input,i+di1,j+dj1) != '#'
  end
end

def becomes_free input, i, j
  get(input,i,j) == '#' &&
  [[0,1], [1,0], [-1, 0], [0, -1], [-1,1], [-1,-1],[1,-1],[1,1]].map do |di, dj|
    di1 = di
    dj1 = dj
    # seat = get(input,i+di1,j+dj1)
    # while seat == '.' do
    #   di1 += di
    #   dj1 += dj
    #   seat = get(input,i+di1,j+dj1)
    # end
    get(input,i+di1,j+dj1) == '#'
  end.count(true) >= 4 # 4 -> 5 for part 2
end

def step input
  new_input = Array.new($height) {Array.new($width)}
  (0..$height-1).each do |i|
    (0..$width-1).each do |j|
      if becomes_occupied(input, i, j) then
        new_input[i][j] = '#'
        $modified = true
      elsif becomes_free(input, i, j) then
        new_input[i][j] = 'L'
        $modified = true
      else
        new_input[i][j] = input[i][j]
      end
    end
  end
  new_input
end

new_input = nil
$modified = nil
while $modified != false do
  $modified = false
  new_input = step(input)
  input = new_input
end

p input.flatten.count('#')
