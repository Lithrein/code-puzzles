NB. Write an APL dfn which returns a 1 if the opening and closing parentheses in
NB. a character vector are balanced, or a zero otherwise.

bal =. ((0={:)*(0=+/&(0&(>&[))))&(+/\&(([&('('&=))+(-&(')'&=))))
NB. f =. +/\&(([&('('&=))+(-&(')'&=)))
NB. u =. 0={:
NB. v =. 0=+/&(0&(>&[))
NB. bal =. (u*v) f
bal '((2×3)+4)'
NB. -> is 1
bal ''
NB. -> is 1
bal 'hello world!'
NB. -> is 1
bal ')(2×3)+4('
NB. -> is 0
bal '(()'
NB. -> is 0
bal ')'
NB. -> is 0
bal '('
NB. -> is 0
bal '(a)'
NB. -> is 1
