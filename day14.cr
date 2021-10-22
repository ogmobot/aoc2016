require "digest/md5"
input = "ahsbgdzn"

def md5_2017 ( s )
    (0..2016).each do
        s = Digest::MD5.hexdigest s
    end
    return s
end

def contains_run ( len, s )
    s.chars.each_cons(len) do |con|
        return con[0].to_i(16) if con.all?(con[0])
    end
    return nil
end

def find_quints ( prefix, lowval, highval, results, hash_function )
    lowval.upto( highval ) do |val|
        s = hash_function.call("#{prefix}#{val}")
        if quint_digit = contains_run 5, s
            results[quint_digit] << val
        end
    end
end

def main ( hash_function, prefix )
    quints = Array(Array(Int32)).new
    (0...16).each do quints << [] of Int32 end
    keys = [] of Int32
    val = 0
    maxquint = 2000
    find_quints prefix, 0, maxquint, quints, hash_function
    loop do
        s = hash_function.call("#{prefix}#{val}")
        if tri_digit = contains_run 3, s
            if quints[tri_digit].any? { |i| i > val && i < val + 1000 }
                keys << val
                break if keys.size >= 64
            end
        end
        val += 1
        if val + 1000 >= maxquint
            maxquint += 1000
            find_quints prefix, maxquint-999, maxquint, quints, hash_function
        end
    end
    puts keys[-1]
end

# part 1
main (->(x : String) { Digest::MD5.hexdigest(x) }), input
# part 2 (takes ~3min)
main (->(x : String) { md5_2017(x) }), input
