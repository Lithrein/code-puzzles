NB. Write a dfn which produces n month moving averages for a year’s worth of
NB. data.

sales =. 200 300 2700 3400 100 2000 400 2100 3500 3000 4700 4300
movavg =. {{ ( x %~ ( x ([+/\]) y ) ) }}
movavg =. {{(([+/\])y&%)x}}
movavg =. (+/\&]~&[%])~

2 movavg sales
NB. 250 1500 3050 1750 1050 1200 1250 2800 3250 3850 4500
10 movavg sales
NB. 1770 2220 2620
1 movavg sales
NB. 200 300 2700 3400 100 2000 400 2100 3500 3000 4700 4300
