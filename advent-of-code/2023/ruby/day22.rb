lines = File.open('../inputs/22.txt').readlines.map(&:chomp)

idx = 0
bricks = []
lines.each do |line|
  st, ed = line.split('~').map { |x| x.split(',').map(&:to_i) }
  st_x, st_y, st_z = st
  ed_x, ed_y, ed_z = ed

  blocks = []
  (st_x..ed_x).each do |x|
    (st_y..ed_y).each do |y|
      (st_z..ed_z).each do |z|
        blocks << [x,y,z] 
      end
    end
  end

  bricks[idx] = blocks
  idx += 1
end

def collide?(board, ref)
  board.each.with_index do |brick, idx|
    brick.each do |block|
      if block[0] == ref[0] && block[1] == ref[1] && block[2] == ref[2] then
        return idx
      end
    end
  end
  return false
end

def above(board, brick, idx)
  above_set = []
  brick.each.with_index do |block|
    s = collide?(board, [block[0], block[1], block[2] + 1])
    above_set << s if s != false && s != idx
  end
  above_set.uniq
end

def hard_drop(board, brick)
  can_move = true
  dz = 0

  while can_move do
    dz += 1
    brick.each do |block|
      can_move = can_move && (1 <= (block[2] - dz)) && false == collide?(board, [ block[0], block[1], block[2] - dz])
    end
  end

  dz = [ dz - 1, 0].max
  new_brick = []
  brick.each do |block|
    new_brick << [block[0], block[1], block[2] - dz]
  end
  board << new_brick
end

def lowest(bricks)
  z_min = 1_000_000
  idx_min = 0
  bricks.each.with_index do |brick, idx|
    brick.each do |block|
      if block[2] < z_min then
        z_min = block[2]
        idx_min = idx
      end
    end
  end
  idx_min
end

board = []

while bricks.size != 0 do
  p bricks.size
  lowest_idx = lowest(bricks)
  hard_drop(board, bricks[lowest_idx])
  bricks = if lowest_idx == 0 then 
             bricks[1..-1]
           elsif lowest_idx == bricks.size - 1
             bricks[0..-2]
           else
             bricks[0..lowest_idx-1] + bricks[lowest_idx+1..-1]
           end
end
puts "all blocks are down"

above_sets = []
board.each.with_index do |brick, idx|
  p idx
  above_sets << above(board, brick, idx)
  puts "#{brick} #{above(board, brick, idx)}"
end

puts "all above_sets are ok"

sum = 0
(0..above_sets.size-1).each do |idx_|
  p idx_
  without = []
  above_sets.each.with_index do |as, idx|
    without += as & above_sets[idx_] if idx_ != idx
  end
  ok = without.sort == above_sets[idx_].sort
  sum += 1 if ok
end

puts "the answer is:"
p sum
