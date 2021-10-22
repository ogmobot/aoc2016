#!/usr/bin/ijconsole

maxnum=:10000000
plink=:{{(1{y)|(x+(0{y)+(2}y))}}
NB. TODO rewrite this as a composition
solve=:{{(*/0=(i.maxnum)plink"1 y)i.1}}

NB. hard-coded to avoid needing to parse text
input1=:1 13 1, 2 19 10, 3 3 2, 4 7 1, 5 5 3,: 6 17 5
input2=:input1, 7 11 0

echo ,.solve@>(<input1),<input2
exit''
