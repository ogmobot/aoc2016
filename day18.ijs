#!/usr/bin/ijconsole

input=:,>cutopen toJ 1!:1<'input18.txt'

NB.6 3 4 1 == 110 011 100 001 generate traps
gen=:'|',~'|','.^'{~[:+./(6 3 4 1)=/3#.\'^'&=
NB. part 1
traproom=:gen^:(i.40)'|',~'|',input
echo +/+/('.'&=)traproom
NB. part 2
traproom=:gen^:(i.400000)'|',~'|',input
echo +/+/('.'&=)traproom

exit''
