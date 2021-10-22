#!/usr/bin/ijconsole

input=: > cutopen toJ 1!:1 < 'input06.txt'

freq=:[:+/(=/~.)

echo ({.@\:@freq{~.)"1|:input
echo ({.@/:@freq{~.)"1|:input
exit''
