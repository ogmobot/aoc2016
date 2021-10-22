def count_ones( n : Int32 )
    total = 0
    while n > 0
        total += (n % 2)
        n //= 2
    end
    return total
end

def wall_at? ( location : Tuple(Int32, Int32), fav )
    x, y = location
    return true if x < 0 || y < 0
    return count_ones((x*x) + (3*x) + (2*x*y) + y + (y*y) + fav) % 2 == 1
end

def path_to (
        start : Tuple(Int32, Int32),
        target : Tuple(Int32, Int32),
        fav = Int32 )
    seen = Set(Tuple(Int32, Int32)).new
    seen << start 
    paths = [[start]]
    while paths.size > 0
        candidate = paths.shift
        last_space = candidate[-1]
        return candidate if last_space == target
        seen << last_space
        [{-1, 0}, {0, -1}, {1, 0}, {0, 1}].each do |dx, dy|
            new_space = {last_space[0] + dx, last_space[1] + dy}
            unless ((seen.includes? new_space) || (wall_at? new_space, fav))
                paths << (candidate + [new_space])
            end
        end
    end
    return nil
end

def flood_fill (
        start : Tuple(Int32, Int32),
        max_distance : Int32,
        fav = Int32 )
    seen = Set(Tuple(Int32, Int32)).new
    seen << start 
    paths = [[start]]
    while paths.size > 0
        candidate = paths.shift
        next if candidate.size - 1 > max_distance
        last_space = candidate[-1]
        seen << last_space
        [{-1, 0}, {0, -1}, {1, 0}, {0, 1}].each do |dx, dy|
            new_space = {last_space[0] + dx, last_space[1] + dy}
            unless ((seen.includes? new_space) || (wall_at? new_space, fav))
                paths << (candidate + [new_space])
            end
        end
    end
    return seen
end

input = 1358

part1 = path_to({1, 1}, {31, 39}, input)
if part1
    puts part1.size - 1
else
    puts "No path found."
end
part2 = flood_fill({1, 1}, 50, input)
puts part2.size
