$red_max = 12
$green_max = 13
$blue_max = 14
$sum = 0

$lines = File.open('2.txt').readlines

$lines.each do |l|
  game_id, sets = l.chomp.split(': ').map.with_index { |a,i| if i == 0 then a[4..].to_i else a.split('; ') end }
  good = true

  sets.each do |draws|
    scoreboard = Hash.new 0
    draws.split(', ').each do |draw|
      val, color = draw.split(' ').map.with_index { |a, i| if i == 0 then a.to_i else a end }
      scoreboard[color] += val
      if not (scoreboard['red'] <= $red_max && scoreboard['green'] <= $green_max && scoreboard['blue'] <= $blue_max) then
        good = false
      end
    end
  end
  if good then
    $sum += game_id
  end
end
p $sum

$sum = 0
$lines.each do |l|
  game_id, sets = l.chomp.split(': ').map.with_index { |a,i| if i == 0 then a[4..].to_i else a.split('; ') end }

  set_scoreboard = Hash.new 0
  sets.each do |draws|
    scoreboard = Hash.new 0
    draws.split(', ').each do |draw|
      val, color = draw.split(' ').map.with_index { |a, i| if i == 0 then a.to_i else a end }
      scoreboard[color] += val
    end
    set_scoreboard['blue'] = [set_scoreboard['blue'], scoreboard['blue']].max
    set_scoreboard['red'] = [set_scoreboard['red'], scoreboard['red']].max
    set_scoreboard['green'] = [set_scoreboard['green'], scoreboard['green']].max
  end
  $sum += set_scoreboard['blue'] * set_scoreboard['red'] * set_scoreboard['green']
end
p $sum
