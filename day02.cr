def step_rect (current, direction)
    case direction
    when 'U'
        if current > 3
            return current - 3
        end
    when 'R'
        if (current % 3) != 0
            return current + 1
        end
    when 'D'
        if current <= 6
            return current + 3
        end
    when 'L'
        if (current % 3) != 1
            return current - 1
        end
    end
    return current
end

def step_diamond (current, direction)
    case direction
    when 'U'
        val = {
             3 =>  1,
             6 =>  2,  7 => 3,  8 => 4,
            10 =>  6, 11 => 7, 12 => 8,
            13 => 11
        }[current]?
        if val
            return val
        end
    when 'R'
        if ![1, 4, 9, 12, 13].any?(current)
            return current + 1
        end
    when 'D'
        val = {
             1 =>  3,
             2 =>  6, 3 =>  7, 4 =>  8,
             6 => 10, 7 => 11, 8 => 12,
            11 => 13
        }[current]?
        if val
            return val
        end
    when 'L'
        if ![1, 2, 5, 10, 13].any?(current)
            return current - 1
        end
    end
    return current
end

lines = File.read_lines "input02.txt"

# part 1
last_seen = 5
buffer = ""
lines.each do |line|
    line.each_char do |ch|
        last_seen = step_rect(last_seen, ch)
    end
    buffer += last_seen.to_s
end
puts buffer
# part 2
last_seen = 5
buffer = ""
lines.each do |line|
    line.each_char do |ch|
        last_seen = step_diamond(last_seen, ch)
    end
    buffer += last_seen.to_s(16).upcase
end
puts buffer
