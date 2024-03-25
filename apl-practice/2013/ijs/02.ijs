NB. 2. Making The Grade
NB. Write a dfn which returns the percent (from 0 to 100) of passing
NB. (65 or higher) grades in a vector of grades.

u =. 100 * ((+/&((>&65)+(=&65)))%#)
u 25 90 100 64 65
NB. 60
u 50
NB. 50
u 80 90 100
NB. 100
u i. 0
NB. 0. (Different from the problem. No grades are passing (in the problem it was
NB. all grades).
