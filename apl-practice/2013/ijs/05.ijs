NB. Write an APL dfn which produces an n×n identity matrix.

id =. {{ 0 = (2$y) $ i. (y + 1) }} 5
id =. 0=((2&$)$(i.&(+&1)))
id 5
NB. 1 0 0 0 0
NB. 0 1 0 0 0
NB. 0 0 1 0 0
NB. 0 0 0 1 0
NB. 0 0 0 0 1
id 1
NB. 1
id 0
NB. should return a 0×0 matrix
