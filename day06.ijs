#!/usr/bin/ijconsole
input=: > cutopen toJ 1!:1 < 'input06.txt'
freq=:[:+/(=/~.)
NB. first,last @ grade @ (freqtable) index unique-letters
echo |:(({.,{:)@\:@freq{~.)"1|:input
exit''
