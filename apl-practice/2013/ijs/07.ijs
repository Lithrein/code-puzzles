NB.Write a dfn which selects the floating point (non-integer) numbers from a
NB.numeric vector.

int =. ((]=<.)#])
flt =. ((-.&(]=<.))#])

flt 14.2 9 _3 3.1 0 _1.1
NB. 14.2 3.1 _1.1
flt 1 3 5
NB. nothing
flt 3.1415
NB. 3.1415
