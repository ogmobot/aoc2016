#!/usr/bin/ijconsole

input=:"."0 '10001001100000001'
dragon=:],0,|.@:-.
pair=:(2,~2%~#)$]
checksum=:(=/@|:@pair)^:(0=2|#)^:_
solve=:{{checksum x$dragon^:(x>#)^:_ y}}

NB.Or, substituting:
NB.solve=:{{((=/@|:@((2,~2%~#)$]))^:(0=2|#)^:_)x$(],0,|.@:-.)^:(x>#)^:_ y}}

NB. part 1
echo ,":"0 (272 solve input)
NB. part 2
echo ,":"0 (35651584 solve input)

exit''
