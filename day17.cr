require "digest/md5"
input = "dmypynyp"

def location ( path )
    return {
        path.chars.map{ |c| {'U'=>0,'D'=>0,'L'=>-1,'R'=>1}[c] }.sum, #x
        path.chars.map{ |c| {'U'=>-1,'D'=>1,'L'=>0,'R'=>0}[c] }.sum  #y
    }
end

def oob? ( path )
    xy = location path
    return (xy[0] < 0 || xy[1] < 0 || xy[0] >= 4 || xy[1] >= 4)
end

def possible_steps ( prefix, path )
    doorhash = Digest::MD5.hexdigest("#{prefix}#{path}")
    result = [] of Char
    [{0, 'U'}, {1, 'D'}, {2, 'L'}, {3, 'R'}].each do |index, direction|
        if (doorhash[index].to_i(16) > 10 && !oob? (path + direction))
            result << direction
        end
    end
    return result
end

def find_path ( prefix , target , get_shortest? )
    paths = [""]
    longest = ""
    while paths.size > 0
        candidate = paths.shift
        if (location candidate) == target
            return candidate if get_shortest?
            if candidate.size > longest.size
                longest = candidate
            end
            next
        end
        (possible_steps prefix, candidate).each do |c|
            paths << (candidate + c)
        end
    end
    return longest
end

# part 1
puts find_path input, {3, 3}, true
# part 2 (takes ~45 sec)
puts (find_path input, {3, 3}, false).size
