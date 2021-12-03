input =. 1!:1<'../inputs/day03'
gamma =. {{y > ((# <;._2 input) % 2) }} +/ {{ ". > ((#y)$1) <;.1 y }} ;._2 input
epsilon =. {{ 0 = y }} gamma
(#. gamma) * (#. epsilon)
