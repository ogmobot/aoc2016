def safe ( val )
    return val if val
    return 0
end

def mutate_array ( command, chars )
    if m = /swap position (?<x>[0-9]+) with position (?<y>[0-9]+)/.match command
        x, y = {m.["x"].to_i, m.["y"].to_i}
        chars[x], chars[y] = {chars[y], chars[x]}
    elsif m = /swap letter (?<x>[a-z]) with letter (?<y>[a-z])/.match command
        x, y = { safe(chars.index m.["x"][0]), safe(chars.index m.["y"][0]) }
        chars[x], chars[y] = {chars[y], chars[x]}
    elsif m = /rotate (?<a>left|right) (?<x>[0-9]+) steps?/.match command
        x = m.["x"].to_i
        (x = -x) if m.["a"] == "right"
        chars.rotate! x
    elsif m = /rotate based on position of letter (?<x>[a-z])\*?/.match command
        x = safe(chars.index m.["x"][0])
        if command.ends_with? "*"
            chars.rotate! ([1, 1, 6, 2, 7, 3, 0, 4][x]) # lookup table's easier than formula
        else
            if x >= 4
                x = x + 1
            end
            chars.rotate! -(x + 1)
        end
    elsif m = /reverse positions (?<x>[0-9]+) through (?<y>[0-9]+)/.match command
        x, y = {m.["x"].to_i, m.["y"].to_i}
        chars[x..y].reverse.each_with_index do |c, i|
            chars[x + i] = c
        end
    elsif m = /move position (?<x>[0-9]+) to position (?<y>[0-9]+)/.match command
        x, y = {m.["x"].to_i, m.["y"].to_i}
        c = chars[x]
        chars.delete_at x
        chars.insert y, c
    end
end

def reverse_of ( command )
    if command.starts_with? "rotate based on"
        return command + "*"
    elsif m = /move position (?<x>[0-9]+) to position (?<y>[0-9]+)/.match command
        x, y = {m.["x"], m.["y"]}
        return "move position #{y} to position #{x}"
    elsif command.includes? "left"
        return command.gsub("left", "right")
    else
        return command.gsub("right", "left")
    end
end

commands = File.read_lines "input21.txt"

# part 1
password = "abcdefgh".chars
commands.each do |command|
    mutate_array command, password
end
puts password.join


# part 2
password = "fbgdceah".chars
commands.map{ |orig| reverse_of orig }.reverse.each do |command|
    mutate_array command, password
end
puts password.join
