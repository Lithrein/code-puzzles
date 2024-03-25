NB. Write a dfn which returns the number of words character vector.  For
NB. simplicity’s sake, you can consider the space character ‘ ‘ to be the only
NB. word separator.

u =. +/&(]%])&(#;._2&(,&' '))
u 'Testing one, two, three'
NB. u 'Testing one, two, three' is 4
u ''
NB. u '' is 0
u ' this vector has extra blanks '
NB. u ' this vector has extra blanks ' is 5
NB. just counting the blanks won't work.
