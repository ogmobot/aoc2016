lines = File.read_lines "input15.txt"
input = lines.map { |line|
    if m = /Disc #(?<id>[0-9]+) has (?<size>[0-9]+) positions; at time=0, it is at position (?<initial>[0-9]+)\./.match(line)
        {m.["id"].to_i, m.["size"].to_i, m.["initial"].to_i}
    else
        {-1, -1, -1}
    end
}

def plink ( discs , t )
    return discs.all? { |id, size, initial|
        (t + id + initial) % size == 0
    }
end

# This is a Chinese Remainder Theorem problem, but we can brute-force it

def brute_force ( discs )
    (0..).each do |t|
        if t > 10000000
            puts "Brute force failed :("
            return 0
        end
        if plink discs, t
            return t
        end
    end
end

puts brute_force ( input )
input << {7, 11, 0}
puts brute_force ( input )
