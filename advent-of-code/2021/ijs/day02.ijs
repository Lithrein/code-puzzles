input   =. 1!:1<'../inputs/day02'
part1   =. 3 : 0
  up      =. {{ 0,-y }}
  down    =. {{ 0,y }}
  forward =. {{ y,0 }}
  */+/".;._2 y
)
part1 input

part2 =. 3 : 0
  up      =. {{ 0,-y,0 }}
  down    =. {{ 0,y,0 }}
  forward =. {{ y,0,0 }}
  op      =. {{ y+(>(0={.x){(<(0,({.x),({.x*{.y))),(<(+/x),0,0)) }}
  */}.op/ (|.".;._2 y),(3$0)
)
part2 input
