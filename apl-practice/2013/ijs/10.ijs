NB. Many people have taken some sort of algebra class where you are presented
NB. with a set of linear equations like:

NB. 3x + 2y = 13 x - y = 1
NB. The answer in this case is x=3 and y=2

NB. Write a dfn which solves this type of problem. Hint: this is the easiest of
NB. all of the problems presented here.

NB. The left argument is a vector of the values for the equations and the right
NB. argument is a matrix of the coefficients.

solve =. {{ (%.y) +/ .* x }}
solve =. ((+/ .*)])~%.

13 1 solve 2 2 $ 3 2 1 _1
NB. 3 2
2 6 4 solve 3 3 $ 4 1 3 2 2 2 6 3 1
NB. _1 3 1
