sols = []

for vx in 0..309 do
  for vy in -78..78 do
    vxx = vx
    vyy = vy
    x = 0
    y = 0
    for n in 0..200 do
      x += vxx
      y += vyy
      if 287 <= x && x <= 309 && -76 <= y && y <= -48 then
        sols << [vx, vy]
        break
      end
      vxx -= 1 unless vxx == 0
      vyy -= 1
    end
  end
end

p sols.map { |a,b| b * (b + 1) / 2 }.max
p sols.size
