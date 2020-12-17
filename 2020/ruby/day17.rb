#! /usr/bin/env ruby

def active_neighbors_3 tab, i, j, k
  neighbors = [-1,-1,-1,0,0,1,1,1].permutation(3).uniq
  neighbors.map { |di,dj,dk|
    0 <= i+di && i+di < tab.length &&
    0 <= j+dj && j+dj < tab[0].length &&
    0 <= k+dk && k+dk < tab[0][0].length &&
    tab[i+di][j+dj][k+dk] == '#' ? 1 : 0
  }.sum
end

def copy tab
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

def iter_3 tab
  new_tab = copy tab

  tab.length.times do |i|
    tab[0].length.times do |j|
      tab[0][0].length.times do |k|
        an = active_neighbors_3(tab,i,j,k)
        if tab[i][j][k] == '#' then
          if !(an == 2 || an == 3) then
            new_tab[i][j][k] = '.'
          end
        elsif an == 3 && tab[i][j][k] == '.' then
            new_tab[i][j][k] = '#'
        end
      end
    end
  end
  new_tab
end

def print_tab tab
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

  (input.length + 2*n).times do |i|
    (input[0].length + 2*n).times do |j|
      (1 + 2*n).times do |k|
        if k == n && i >= n && i < n + input.length && j >= n && j < n + input[0].length then
          tab[i][j][k] = input[i-n][j-n]
        else
          tab[i][j][k] = '.'
        end
      end
    end
  end

  n.times do |n|
    puts n
    tab = iter_3 tab
  end

  tab.map { |sa| sa.join.count '#' }.sum
end

def part2

end

input = File.open('../inputs/day17').readlines.map(&:chomp).map { |s| s.split '' }
#input = <<-DATA
#.#.
#..#
####
#DATA
#input = input.split("\n").map { |s| s.split '' }
# p input
p part1(input,6)
# p part2(input)
