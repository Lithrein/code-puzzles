lines = File.open('../inputs/7ex1.txt').readlines.map(&:chomp)

cards = lines.map do |line|
  card, bid = line.split(' ')
  bid = bid.to_i
  [card, bid]
end

cards = cards.sort do |card1, card2|
  values = [ card1[0], card2[0] ]

  combis = [ 0, 0 ]

  values.each.with_index do |value, i|
    h = Hash.new 0
    value.split('').each do |v| h[v] += 1 end
    tmp = h.map { |(k,v)| v}

    # High Card
    combis[i] = 1 if tmp.select { |a| a == 1 }.size == 5

    # Pair
    combis[i] = 2 if tmp.select { |a| a == 2 }.size == 1

    # Double Pair
    combis[i] = 3 if tmp.select { |a| a == 2 }.size == 2

    # Three of a kind
    combis[i] = 4 if tmp.select { |a| a == 3 }.size == 1

    # Full House
    combis[i] = 5 if (tmp.select { |a| a == 3 }.size == 1 && tmp.select { |a| a == 2 }.size == 1)

    # Four of a kind
    combis[i] = 6 if tmp.select { |a| a == 4 }.size == 1

    # Fifth of a kind
    combis[i] = 7 if tmp.select { |a| a == 5 }.size == 1
  end

  if combis[0] == combis[1] then
    values[0].split('').map { |a| if a == 'A' then 14 elsif a == 'K' then 13 elsif a == 'Q' then 12 elsif a == 'J' then 11 elsif a == 'T' then 10 else a.to_i end } <=> \
    values[1].split('').map { |a| if a == 'A' then 14 elsif a == 'K' then 13 elsif a == 'Q' then 12 elsif a == 'J' then 11 elsif a == 'T' then 10 else a.to_i end }
  else
    combis[0] <=> combis[1]
  end
end

p cards.map.with_index { |card,i| card[1] * (i + 1)}.sum

def best clist
  if clist.include? 'A' then 'A'
  elsif clist.include? 'K' then 'K'
  elsif clist.include? 'Q' then 'Q'
  elsif clist.include? 'T' then 'T'
  else "#{clist.map(&:to_i).max}"
  end
end

cards = cards.sort do |card1, card2|
  values = [ card1[0], card2[0] ]

  combis = [ 0, 0 ]

  values.each.with_index do |value, i|
    h = Hash.new 0
    value.split('').each do |v| h[v] += 1 end
    tmp = h.map { |(k,v)| v}

    if value.include? 'J' then
      h['J'] = -1
      tmp = h.map { |(k,v)| v}
      m = tmp.max
      c = best(h.select { |k, v| v == m }.keys)
      value = value.gsub(/J/, c)
      h = Hash.new 0
      value.split('').each do |v| h[v] += 1 end
      tmp = h.map { |(k,v)| v}
    end

    # High Card
    combis[i] = 1 if tmp.select { |a| a == 1 }.size == 5

    # Pair
    combis[i] = 2 if tmp.select { |a| a == 2 }.size == 1

    # Double Pair
    combis[i] = 3 if tmp.select { |a| a == 2 }.size == 2

    # Three of a kind
    combis[i] = 4 if tmp.select { |a| a == 3 }.size == 1

    # Full House
    combis[i] = 5 if (tmp.select { |a| a == 3 }.size == 1 && tmp.select { |a| a == 2 }.size == 1)

    # Four of a kind
    combis[i] = 6 if tmp.select { |a| a == 4 }.size == 1

    # Fifth of a kind
    combis[i] = 7 if tmp.select { |a| a == 5 }.size == 1
  end

  if combis[0] == combis[1] then
    values[0].split('').map { |a| if a == 'A' then 14 elsif a == 'K' then 13 elsif a == 'Q' then 12 elsif a == 'J' then 1 elsif a == 'T' then 10 else a.to_i end } <=> \
    values[1].split('').map { |a| if a == 'A' then 14 elsif a == 'K' then 13 elsif a == 'Q' then 12 elsif a == 'J' then 1 elsif a == 'T' then 10 else a.to_i end }
  else
    combis[0] <=> combis[1]
  end
end

p cards
p cards.map.with_index { |card,i| card[1] * (i + 1)}.sum
