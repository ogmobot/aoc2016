def split_brackets (s)
    in_bracket = [] of String
    out_bracket = [] of String
    while s.index /\[|\]/
        parts = s.partition /\[[^\]]*\]/
        in_bracket << parts[1].lchop('[').rchop(']')
        out_bracket << parts[0]
        s = parts[2]
    end
    out_bracket << s
    return {in_bracket, out_bracket}
end

def has_abba (s)
    # operates on a substring
    s.chars.each_cons(4, true) do |cons|
        if (cons[0] == cons[3] && cons[1] == cons[2] && cons[0] != cons[1])
            return true
        end
    end
    return false
end

def has_aba_bab (s)
    # operates on entire string
    in_bracket, out_bracket = split_brackets s
    ab_pairs = [] of String
    out_bracket.each do |s|
        s.chars.each_cons(3, true) do |t|
            if (t[0] == t[2] && t[0] != t[1])
                ab_pairs << t[0, 2].join
            end
        end
    end
    in_bracket.each do |s|
        s.chars.each_cons(3, true) do |t|
            if (t[0] == t[2] && t[0] != t[1] && ab_pairs.includes? t[1, 2].join)
                return true
            end
        end
    end
    return false
end

lines = File.read_lines "input07.txt"

# part 1
puts lines.count { |line|
    in_bracket, out_bracket = split_brackets line
    out_bracket.any? { |sub|
        has_abba sub
    } && !in_bracket.any? { |sub|
        has_abba sub
    }
}
# part 2
puts lines.count { |line| has_aba_bab line }
