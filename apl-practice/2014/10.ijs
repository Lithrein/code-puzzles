NB. Given a vector representing monthly sales figures, write a dfn that returns
NB. the greatest percent month to month increase.

m =. >./@:(100&*&<:&(}.%}:))
m =. [:>./100*1-~}.%}:

m 80 100 120 140 NB. 25
m 123 123 123 NB. 0
m 101 102 114 117 101 110 102 111 118 115 124 122 NB. 11.7647
m 200 180 160 140 120 NB. _10
