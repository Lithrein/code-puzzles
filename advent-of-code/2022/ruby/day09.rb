input = File.open('../inputs/day09').readlines

def dist_sq x,y
  [(x[0]-y[0]).abs, (y[1]-x[1]).abs].max
end

# p1: nb_tls = 1; p2 nb_tls = 9
nb_tls = 9
tls = [ [0,0], [0,0], [0,0], [0,0], [0,0], [0,0], [0,0], [0,0], [0,0], [0,0] ]
pos = {}
pos[[tls[nb_tls - 1][0],tls[nb_tls - 1][1]]] = 1
input.each do |line|
  dir, jmp_sz = line.match(/(.) (\d+)/)[1..-1]
  jmp_sz = jmp_sz.to_i

  # head moves
  jmp_sz.times do
    case dir
    when "R" then tls[0][0] += 1
    when "L" then tls[0][0] -= 1
    when "U" then tls[0][1] += 1
    when "D" then tls[0][1] -= 1
    else puts "Bad input #{dir}."; exit
    end

    # tailes catches up
    nb_tls.times do |i|
      if dist_sq(tls[i], tls[i+1]) > 1 then
        if tls[i][0] == tls[i+1][0] then #horiz same
          if tls[i][1] < tls[i+1][1] then tls[i+1][1] -= 1 else tls[i+1][1] += 1 end
        elsif tls[i][1] == tls[i+1][1] then #vert same
          if tls[i][0] < tls[i+1][0] then tls[i+1][0] -= 1 else tls[i+1][0] += 1 end
        else #diag
          if tls[i][1] < tls[i+1][1] then tls[i+1][1] -= 1 else tls[i+1][1] += 1 end
          if tls[i][0] < tls[i+1][0] then tls[i+1][0] -= 1 else tls[i+1][0] += 1 end
        end
        pos[[tls[nb_tls][0], tls[nb_tls][1]]] = 1
      end
    end
  end
end

puts "#{pos.keys.size}"
