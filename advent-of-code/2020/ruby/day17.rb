#! /usr/bin/env ruby

require './utils'

module Day17
  extend self

  @neighbors3 = [-1,0,1].product([-1,0,1],[-1,0,1]) - [[0,0,0]]
  @neighbors4 = [-1,0,1].product([-1,0,1],[-1,0,1],[-1,0,1]) - [[0,0,0,0]]

  def active_neighbors_3 tab, i, j, k
    @neighbors3.map { |di,dj,dk|
      0 <= i+di && i+di < tab.length &&
        0 <= j+dj && j+dj < tab[0].length &&
        0 <= k+dk && k+dk < tab[0][0].length &&
        tab[i+di][j+dj][k+dk] == '#' ? 1 : 0
    }.sum
  end

  def active_neighbors_4 tab, i, j, k, l
    @neighbors4.map { |di,dj,dk,dl|
      0 <= i+di && i+di < tab.length &&
        0 <= j+dj && j+dj < tab[0].length &&
        0 <= k+dk && k+dk < tab[0][0].length &&
        0 <= l+dl && l+dl < tab[0][0][0].length &&
        tab[i+di][j+dj][k+dk][l+dl] == '#' ? 1 : 0
    }.sum
  end


  def print_tab_3 tab
    z = tab[0][0].length

    z.times do |k|
      puts "z = #{k - z/2}"
      tab.length.times do |i|
        tab[0].length.times do |j|
          print "#{tab[i][j][k]}"
        end
        puts ""
      end
      puts "\n"
    end
  end

  def part1 input, n
    tab = Array.new (input.length+2*n) { Array.new (input[0].length+2*n) { Array.new (1+2*n) } }
    active_cells = []

    (input.length + 2*n).times do |i|
      (input[0].length + 2*n).times do |j|
        (1 + 2*n).times do |k|
          if k == n && i >= n && i < n + input.length && j >= n && j < n + input[0].length then
            tab[i][j][k] = input[i-n][j-n]
            active_cells += [[i,j,k]] if input[i-n][j-n] == '#'
          else
            tab[i][j][k] = '.'
          end
        end
      end
    end

    n.times do |n|
      new_tab = Utils.deepcopy tab
      min_x, max_x = active_cells.map {|a,_,_| a}.minmax
      min_y, max_y = active_cells.map {|_,a,_| a}.minmax
      min_z, max_z = active_cells.map {|_,_,a| a}.minmax

      (min_x-1..max_x+1).each do |i|
        (min_y-1..max_y+1).each do |j|
          (min_z-1..max_z+1).each do |k|
            an = active_neighbors_3(tab,i,j,k)
            if tab[i][j][k] == '#' && !(an == 2 || an == 3) then
              new_tab[i][j][k] = '.'
              active_cells -= [[i,j,k]]
            elsif an == 3 && tab[i][j][k] == '.' then
              new_tab[i][j][k] = '#'
              active_cells += [[i,j,k]]
            end
          end
        end
      end
      tab = new_tab
    end

    active_cells.length
  end

  def part2 input, n
    tab = Array.new (input.length+2*n) { Array.new (input[0].length+2*n) { Array.new (1+2*n) { Array.new (1+2*n) } } }
    active_cells = []

    (input.length + 2*n).times do |i|
      (input[0].length + 2*n).times do |j|
        (1 + 2*n).times do |k|
          (1 + 2*n).times do |l|
            if l == n && k == n && i >= n && i < n + input.length && j >= n && j < n + input[0].length then
              tab[i][j][k][l] = input[i-n][j-n]
              active_cells += [[i,j,k,l]] if input[i-n][j-n] == '#'
            else
              tab[i][j][k][l] = '.'
            end
          end
        end
      end
    end

    n.times do |n|
      min_x, max_x = active_cells.map {|a,_,_,_| a}.minmax
      min_y, max_y = active_cells.map {|_,a,_,_| a}.minmax
      min_z, max_z = active_cells.map {|_,_,a,_| a}.minmax
      min_w, max_w = active_cells.map {|_,_,_,a| a}.minmax

      new_tab = Utils.deepcopy tab
      (min_x-1..max_x+1).each do |i|
        (min_y-1..max_y+1).each do |j|
          (min_z-1..max_z+1).each do |k|
            (min_w-1..max_w+1).each do |l|
              an = active_neighbors_4(tab,i,j,k,l)
              if tab[i][j][k][l] == '#' && !(an == 2 || an == 3) then
                new_tab[i][j][k][l] = '.'
                active_cells -= [[i,j,k,l]]
              elsif an == 3 && tab[i][j][k][l] == '.' then
                new_tab[i][j][k][l] = '#'
                active_cells += [[i,j,k,l]]
              end
            end
          end
        end
      end
      tab = new_tab
    end

    active_cells.length
  end
end

if $0 == __FILE__ then
  input = File.open('../inputs/day17').readlines.map(&:chomp).map { |s| s.split '' }
  puts "Part 1: #{Day17.part1(input,6)}"
  puts "Part 2: #{Day17.part2(input,6)}"
end
