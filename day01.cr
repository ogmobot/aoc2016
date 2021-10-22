def manhattan_distance (x, y)
    return x.abs + y.abs
end

input_file = File.new "input01.txt"
instructions = input_file.gets_to_end.strip.split ", "
input_file.close

enum Compass
    North
    East
    South
    West
end

direction = Compass::North
x = 0
y = 0
dx = 0
dy = 0
seen = Set { {0, 0} }
target = {0, 0}

instructions.each do |inst|
    if inst.starts_with? 'R'
        direction = Compass.new((direction.value + 1) % 4)
    else
        direction = Compass.new((direction.value - 1) % 4)
    end
    distance = inst.lchop.to_i
    case direction
    when Compass::North
        dy = -1
        dx = 0
    when Compass::East
        dx = 1
        dy = 0
    when Compass::South
        dx = 0
        dy = 1
    when Compass::West
        dx = -1
        dy = 0
    end
    (0...distance).each do
        x += dx
        y += dy
        if seen.includes?({x, y}) && target == {0, 0}
            #puts "Second time we've seen #{x}, #{y}"
            #puts "(Distance=#{manhattan_distance(x, y)})"
            target = {x, y}
        else
            seen.add({x, y})
        end
    end
    #puts "#{inst} => direction=#{direction} x=#{x} y=#{y}"
end

puts "Part 1: #{manhattan_distance(x, y)}"
puts "Part 2: #{manhattan_distance(*target)}"
