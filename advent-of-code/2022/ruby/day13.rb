input = File.open('../inputs/day13').readlines.join.split("\n\n").map { |x| x.split("\n").map { |y| eval(y) }}

def is_ordered(a,b)
  if a.empty? && b.empty? then '='
  elsif !a.empty? && b.empty? then '>'
  elsif a.empty? && !b.empty? then '<'
  else
    hda = a[0]
    tla = a[1..-1] || []
    hdb = b[0]
    tlb = b[1..-1] || []
    if hda.class == Integer && hdb.class == Integer then
      if hda < hdb then
        '<'
      elsif hda == hdb then
        tmp = is_ordered(tla,tlb)
        if ['<', '='].include? tmp then tmp else '>' end
      else
        '>'
      end
    elsif hda.class == Integer && hdb.class == Array then
      tmp = is_ordered([[hda]] + tla,b)
      if ['<', '='].include? tmp then tmp else '>' end
    elsif hdb.class == Integer && hda.class == Array then
      tmp = is_ordered(a,[[hdb]] + tlb)
      if ['<', '='].include? tmp then tmp else '>' end
    else
      tmp = is_ordered(hda,hdb)
      if tmp == '<' then
        '<'
      elsif tmp == '=' then
        is_ordered(tla,tlb)
      else
        '>'
      end
    end
  end
end

i = 1
sum = 0
input.each do |a,b|
  tmp = is_ordered(a,b)
  sum += i if ['<', '='].include? tmp
  i += 1
end

i = 1
prod = 1
input2 = (File.open('../inputs/day13').readlines.join.split("\n\n").map { |x| x.split("\n").map { |y| eval(y) }}.flatten(1) + [[[2]]] + [[[6]]])
  .sort { |a,b|
  case is_ordered(a,b)
  when '<' then -1
  when '>' then 1
  else 0
  end
}.each do |l|
  prod *= i if is_ordered(l,[[6]]) == '=' || is_ordered([[2]], l) == '='
  i += 1
end
p sum
p prod
