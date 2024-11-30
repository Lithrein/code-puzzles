lines = File.open('../inputs/19.txt').readlines.join

systems, parts = lines.split("\n\n").map { |a| a.split("\n") }

h = {}
systems.each do |s|
  _ , key, contents = s.match(/(.*){(.*)}/).to_a
  h[key] = contents.split(',').map { |a| a.split(':') }.map { |l| if l.size == 1 then ["true", l[0]] else l end }
end

sum = 0
parts.each do |p|
  _, x, m, a, s = p.match(/{x=(.*),m=(.*),a=(.*),s=(.*)}/).to_a.map(&:to_i)
  cur = "in"
  while not (cur == "A" || cur == "R") do
    h[cur].each do |(cond, dest)|
      if eval(cond) then
        cur = dest
        break
      end
    end
  end
  sum += [x, m, a, s].sum if cur == "A"
end
p sum

rng = { :x => [ 1, 4000], :m => [1, 4000], :a => [1, 4000], :s => [1, 4000] }

are_ok = []

cnt = 0
workqueue = [ ["in", rng] ]
while !workqueue.empty? do
  st, rngs = workqueue[0]
  workqueue = workqueue[1..-1]

  h[st].each do |(cond, dest)|
    _, var, symb, val = cond.match(/([xmas])([<>])(\d+)/).to_a
    val = val.to_i
    if cond != "true" then
      if symb == ">" then
        fst_rngs = Marshal.load(Marshal.dump(rngs))
        r_gt = eval("[#{val} + 1, rngs[:#{var}][1]]")
        eval("fst_rngs[:#{var}] = #{r_gt}")
        eval("rngs[:#{var}] = [ rngs[:#{var}][0], #{val} ]")
        if dest == "A" then
          are_ok << fst_rngs
        elsif dest == "R" then
          # Nothing
        else
          workqueue << [ dest, fst_rngs ]
        end
      elsif symb == "<"
        fst_rngs = Marshal.load(Marshal.dump(rngs))
        r_lt = eval("[rngs[:#{var}][0], #{val} - 1]")
        eval("fst_rngs[:#{var}] = #{r_lt}")
        eval("rngs[:#{var}] = [ #{val}, rngs[:#{var}][1] ]")
        if dest == "A" then
          are_ok << fst_rngs
        elsif dest == "R" then
          # Nothing
        else
          workqueue << [ dest, fst_rngs ]
        end
      end
    else
      if dest == "A" then
        are_ok << rngs
      elsif dest == "R" then
        # Nothing
      else
        workqueue << [ dest, rngs ]
      end
    end
  end
  cnt += 1
#  if cnt == 2 then
#    p workqueue
#    p are_ok
#    abort
#  end
end

sum = 0
are_ok.each do |a|
  sum += a.keys.map { |b| a[b][1] - a[b][0] + 1 }.inject(&:*) 
end
p sum
