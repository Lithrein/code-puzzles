$h = {}
input = File.open('../inputs/day21').each do |line|
  key, exp = line.split(': ')
  if exp.to_i == 0 then
    op = exp[5]
    left = exp[0..3]
    right = exp[7..10]
    $h[key] = [op, left, right]
  else
    op = :const
    value = exp.to_i
    $h[key] = [op, value]
  end
end

def eval_exp k
  op, left, right = $h[k]
  case op
  when :const then return left
  when '+' then return eval_exp(left) + eval_exp(right)
  when '*' then return eval_exp(left) * eval_exp(right)
  when '-' then return eval_exp(left) - eval_exp(right)
  when '/' then return eval_exp(left) / eval_exp(right)
  end
end

def eval_exp2 k
  op, left, right = $h[k]
  if k == "root" then
    return "(#{eval_exp2(left)} = #{eval_exp2(right)})"
  else
    case op
    when :const then (if k == "humn" then "x" else return "#{left}" end)
  when '+' then return "(#{eval_exp2(left)} + #{eval_exp2(right)})"
  when '*' then return "(#{eval_exp2(left)} * #{eval_exp2(right)})"
  when '-' then return "(#{eval_exp2(left)} - #{eval_exp2(right)})"
  when '/' then return "(#{eval_exp2(left)} / #{eval_exp2(right)})"
  end
end
end

def eval_exp3 k
  op, left, right = $h[k]
  if k == "root" then
    return "(#{eval_exp3(left)} = #{eval_exp3(right)})"
  else
    if op == :const then
      (if k == "humn" then "x" else return left end)
  else
    l = eval_exp3(left)
    r = eval_exp3(right)
    if l.class == Integer && r.class == Integer then
      case op
      when '+' then return l + r
      when '*' then return l * r
      when '-' then return l - r
      when '/' then return l / r
      end
    else
      case op
      when '+' then return "(#{l} + #{r})"
      when '*' then return "(#{l} * #{r})"
      when '-' then return "(#{l} - #{r})"
      when '/' then return "(#{l} / #{r})"
    end
  end
  end
end
end

def eval_exp4 k
  op, left, right = $h[k]
  if k == "root" then
    right = eval_exp4(right).to_f
    left = eval_exp4(left)
    left_real = left.real.to_f
    left_imag = left.imag.to_f
    return ((right - left_real) / left_imag).to_i
  else
    if op == :const then
      (if k == "humn" then Complex(0,1) else return left end)
  else
    l = eval_exp4(left)
    r = eval_exp4(right)
    case op
    when '+' then return l + r
    when '*' then return l * r
    when '-' then return l - r
    when '/' then return l / r
    end
  end
end
end

p eval_exp("root")
#p eval_exp2("root")
#p eval_exp3("root")
p eval_exp4("root")
