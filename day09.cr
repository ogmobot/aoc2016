def decompress (s)
    output = [] of String
    while s.includes? '('
        prefix, control, suffix = s.partition /\([0-9]+x[0-9]+\)/
        if m = /\((?<length>[0-9]+)x(?<multiplier>[0-9]+)\)/.match control
            output << prefix
            (1..m.["multiplier"].to_i).each do
                output << suffix[...m.["length"].to_i]
            end
            s = suffix[m.["length"].to_i..]
        else
            puts "Malformed string: \"#{s}\""
        end
    end
    output << s
    return output.join
end

def decode_control (s, i)
    if m = /\((?<length>[0-9]+)x(?<multiplier>[0-9]+)\)/.match s, i
        return {
            m.["length"].to_i,
            m.["multiplier"].to_i,
            m.["length"].size + m.["multiplier"].size + 3
        }
    else
        return {0, 0, 0}
    end
end

def total_size (s)
    weights = Array(UInt64).new(s.size, 1.to_u64)
    total = 0.to_u64
    index = 0
    while index < s.size
        if s[index] == '('
            length, multiplier, di = decode_control s, index
            index += di
            (index...(index + length)).each do |i|
                weights[i] *= multiplier
            end
        else
            total += weights[index]
            index += 1
        end
    end
    return total
end

input = File.read_lines "input09.txt"

# part 1
puts decompress(input.join).size
# part 2
puts total_size input.join
