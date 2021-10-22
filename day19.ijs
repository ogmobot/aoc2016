#!/usr/bin/ijconsole

input=:3001330

NB. to apply to a range, use e.g. josephus"0 (1+i.10)

josephus=:#.@(1&|.)@#:
echo josephus input

big3=:x:@(3&^)@<.@(3&^.)
cowboy=:(big3<(]-big3)){((]-big3),(2&*-3&*@big3))
echo cowboy input

exit''
