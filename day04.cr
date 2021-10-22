lines = File.read_lines "input04.txt"

def get_room_data (s)
    room_regex = /^(?<name>.*)\-(?<sector_id>[0-9]+)\[(?<checksum>.....)\]$/
    return room_regex.match(s)
end

def freq_table(s)
    return s
        .chars
        .select { |c| c != '-' }
        .reduce(Hash(Char, Int32).new(0)) { |acc, c|
            acc.merge!( { c => acc[c] + 1 } )
        }
end

def get_checksum (s)
    return freq_table(s)
        .to_a
        .map { |x, freq| {-freq, x} }
        .sort
        .map { |freq, x| x }
        .[0..4]
        .join
end

def rotate_string (s, num)
    return s
        .codepoints
        .map { |val|
            if (val == '-'.ord)
                ' '
            else
                (((val + num - ('a'.ord)) % 26) + 'a'.ord).chr
            end
        }
        .join
end

# part 1
valid_rooms = lines
    .compact_map { |s| get_room_data(s) }
    .select { |m| m.["checksum"] == get_checksum(m.["name"]) }
puts valid_rooms
    .map { |m| m.["sector_id"].to_i }
    .sum

# part 2
puts valid_rooms.select { |m|
    /northpole/.match(rotate_string(m.["name"], m.["sector_id"].to_i))
}.first.["sector_id"]
