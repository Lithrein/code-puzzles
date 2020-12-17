#! /usr/bin/env ruby

$neighbors3 = [-1,0,1].product([-1,0,1],[-1,0,1]) - [[0,0,0]]
$neighbors4 = [-1,0,1].product([-1,0,1],[-1,0,1],[-1,0,1]) - [[0,0,0,0]]

def active_neighbors_3 tab, i, j, k
  $neighbors3.map { |di,dj,dk|
    0 <= i+di && i+di < tab.length &&
    0 <= j+dj && j+dj < tab[0].length &&
    0 <= k+dk && k+dk < tab[0][0].length &&
    tab[i+di][j+dj][k+dk] == '#' ? 1 : 0
  }.sum
end

def active_neighbors_4 tab, i, j, k, l
  $neighbors4.map { |di,dj,dk,dl|
    0 <= i+di && i+di < tab.length &&
    0 <= j+dj && j+dj < tab[0].length &&
    0 <= k+dk && k+dk < tab[0][0].length &&
    0 <= l+dl && l+dl < tab[0][0][0].length &&
    tab[i+di][j+dj][k+dk][l+dl] == '#' ? 1 : 0
  }.sum
end

def copy_3 tab
  new_tab = []
  tab.length.times do |i|
    new_tab[i] = tab[i].clone
  end
  tab.length.times do |i|
    tab[0].length.times do |j|
    new_tab[i][j] = tab[i][j].clone
    end
  end
  new_tab
end

def copy_4 tab
  new_tab = []
  tab.length.times do |i|
    new_tab[i] = tab[i].clone
  end
  tab.length.times do |i|
    tab[0].length.times do |j|
    new_tab[i][j] = tab[i][j].clone
    end
  end
  tab.length.times do |i|
    tab[0].length.times do |j|
      tab[0][0].length.times do |k|
        new_tab[i][j][k] = tab[i][j][k].clone
      end
    end
  end
  new_tab
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
    new_tab = copy_3 tab
    min_x = (active_cells.min { |(a,_,_),(b,_,_)| a <=> b })[0]
    max_x = (active_cells.max { |(a,_,_),(b,_,_)| a <=> b })[0]
    min_y = (active_cells.min { |(_,a,_),(_,b,_)| a <=> b })[1]
    max_y = (active_cells.max { |(_,a,_),(_,b,_)| a <=> b })[1]
    min_z = (active_cells.min { |(_,_,a),(_,_,b)| a <=> b })[2]
    max_z = (active_cells.max { |(_,_,a),(_,_,b)| a <=> b })[2]

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
    min_x = (active_cells.min { |(a,_,_,_),(b,_,_,_)| a <=> b })[0]
    max_x = (active_cells.max { |(a,_,_,_),(b,_,_,_)| a <=> b })[0]
    min_y = (active_cells.min { |(_,a,_,_),(_,b,_,_)| a <=> b })[1]
    max_y = (active_cells.max { |(_,a,_,_),(_,b,_,_)| a <=> b })[1]
    min_z = (active_cells.min { |(_,_,a,_),(_,_,b,_)| a <=> b })[2]
    max_z = (active_cells.max { |(_,_,a,_),(_,_,b,_)| a <=> b })[2]
    min_w = (active_cells.min { |(_,_,_,a),(_,_,_,b)| a <=> b })[3]
    max_w = (active_cells.max { |(_,_,_,a),(_,_,_,b)| a <=> b })[3]

    new_tab = copy_4 tab
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

input = File.open('../inputs/day17').readlines.map(&:chomp).map { |s| s.split '' }
#input = <<-DATA
#.#.
#..#
####
#DATA
#input = input.split("\n").map { |s| s.split '' }
p part1(input,6)
p part2(input,6)
