input[0].split('').each_cons(4).map.with_index { |x,i| if x.uniq.size == 4 then i else -1 end }.select { |x| x != -1 }[0] + 4
input[0].split('').each_cons(14).map.with_index { |x,i| if x.uniq.size == 14 then i else -1 end }.select { |x| x != -1 }[0] + 14
