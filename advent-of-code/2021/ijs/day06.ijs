input =. 1!:1<'../inputs/day06'
data =. +/|:(i.9)=/".LF-.~input NB. Beautiful but stolen...
m =. (54 = 9 9 $ i. 99) + (72 = 9 9 $ i. 99) + (1 = 9 9 $ i. 10)
mp =. +/ .*
pow=. {{ mp/ mp~^:(I.|.#:y) x }}
+/ (m pow 80) mp data
+/ (m pow 256) mp data
