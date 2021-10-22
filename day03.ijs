#!/usr/bin/ijconsole

NB. sum @: reduce-and @ transpose @ a < b + c @ transpose @ 012 cycles & {
triangles=:+/@:(*/@|:@({.<[:+/}.)@(0&|:)@((1|.^:(i.3) i.3)&{))

input=:|:".>cutopen toJ 1!:1<'input03.txt'
NB. Part 1
echo triangles input
NB. Part 2
input2=:|:_3]\,input
echo triangles input2

exit''
