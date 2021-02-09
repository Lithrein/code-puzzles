#! /usr/bin/env ruby

module Day12
  extend self

  def part1 input
    current_dir = 'E'
    current_pos = [0,0] # East, North
    dirs = ['E', 'N', 'W', 'S']
    input.each do |c,n|
      dir = c == 'F' ? current_dir : c
      case dir
      when 'N' then
        current_pos[1] += n
      when 'S' then
        current_pos[1] -= n
      when 'E' then
        current_pos[0] += n
      when 'W' then
        current_pos[0] -= n
      when 'L' then
        next_dir = dirs.index(current_dir)
        current_dir = dirs[(next_dir + (n / 90)) % 4]
      when 'R' then
        next_dir = dirs.index(current_dir)
        current_dir = dirs[(next_dir - (n / 90)) % 4]
      end
    end
    current_pos.map {|x| x.abs}.sum
  end

  def cycle array, n
    len = array.length
    array.map.with_index {|_,idx| array[(idx + n) % len]}
  end

  def part2 input
    waypoint = [10,1,0,0] # E, N, W, S
    current_pos = [0,0] # East, North
    input.each do |c,n|
      case c
      when 'N' then
        waypoint[1] += n
      when 'S' then
        waypoint[3] += n
      when 'E' then
        waypoint[0] += n
      when 'W' then
        waypoint[2] += n
      when 'L' then
        waypoint = cycle(waypoint, -n / 90)
      when 'R' then
        waypoint = cycle(waypoint, n / 90)
      when 'F' then
        current_pos[0] += n * (waypoint[0] - waypoint[2])
        current_pos[1] += n * (waypoint[1] - waypoint[3])
      end
    end
    current_pos.map {|x| x.abs}.sum
  end
end

if $0 == __FILE__ then
  input = File.open('../inputs/day12').read.lines.map {|a| [a[0], a[1..-1].to_i]}
  # input = %w[F10 N3 F7 R90 F11].map {|a| [a[0], a[1..-1].to_i]}
  puts "Part 1: #{Day12.part1(input)}"
  puts "Part 2: #{Day12.part2(input)}"
end
