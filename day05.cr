require "digest/md5"
input = "abbhdwsy"

def next_interesting (prefix, val)
    dig = Digest::MD5.hexdigest("#{prefix}#{val}")
    while !(dig.starts_with? "00000")
        val += 1
        dig = Digest::MD5.hexdigest("#{prefix}#{val}")
    end
    #puts "#{val} => #{dig}"
    return {val, dig}
end

buffer_1 = [] of Char
buffer_2 = Hash(Int32, Char).new
val = 0
while buffer_1.size + buffer_2.size < 16
    val, dig = next_interesting input, val
    # part 1
    if buffer_1.size < 8
        buffer_1 << dig[5]
    end
    # part 2
    if (dig[5].to_i(16) < 8 && (!(buffer_2[dig[5].to_i]?)))
        buffer_2[dig[5].to_i] = dig[6]
    end
    val += 1
end
puts buffer_1.join
puts buffer_2.values_at(0, 1, 2, 3, 4, 5, 6, 7).join
