NB. Write a dfn which returns the magnitude of the range (i.e. the difference
NB. between the lowest and highest values) of a numeric array.
m =. ((>./^:_)-(<./^:_))&(>@/:~)
m 19 _3 7.6 22
NB. 25
m 101
NB. 0
m 2 3 $ 10 20 30 40 50 60
NB. 50
m i. 0
NB. should b 0, but is __
