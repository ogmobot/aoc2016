DEBUG = false

def find_vals ( lines )
    result = Hash(Int32, Tuple(Int32, Int32)).new
    lines.each_with_index do |line, row|
        line.chars.each_with_index do |ch, col|
            if ch.ascii_number?
                result[ch.to_i] = {row, col}
            end
        end
    end
    return result
end

def find_shortest_path ( lines, from_coord, to_coord )
    # location tuples are {row, col}
    seen = Set(Tuple(Int32, Int32)).new
    seen << from_coord
    paths = [[from_coord]]
    while paths.size > 0
        candidate = paths.shift
        puts candidate.size
        last_coord = candidate[-1]
        return candidate if last_coord == to_coord
        seen << last_coord
        [{-1, 0}, {0, -1}, {1, 0}, {0, 1}].each do |dr, dc|
            row, col = {last_coord[0] + dr, last_coord[1] + dc}
            unless ((seen.includes? ({row, col})) || (lines[row][col]=='#'))
                paths << (candidate + [{row, col}])
            end
        end
    end
    return nil
end

def maze2graph_orig ( lines )
    # simplify the maze into a Hash of nodes
    result = Hash(Tuple(Int32, Int32), Int32).new
    # Each hash entry is {from, to} => distance;
    # note that result[{A, B}] == result[{B, A}], so we only need to find
    # distances to nodes greater than the current one.
    locations = find_vals ( lines )
    locations.each do |from_val, from_coord|
        puts "Finding paths from #{from_val}..." if DEBUG
        locations.each do |to_val, to_coord|
            next if to_val <= from_val
            if path = find_shortest_path lines, from_coord, to_coord
                result[{from_val, to_val}] = path.size - 1
                result[{to_val, from_val}] = path.size - 1
            # shortest path includes start and end, but number of steps
            # doesn't include start
            end
            puts "Found path to #{to_val}." if DEBUG
        end
    end
    return result
end

def maze2graph ( lines )
    # simplify the maze into a Hash of nodes
    result = Hash(Tuple(Int32, Int32), Int32).new
    # Each hash entry is {from, to} => distance;
    # note that result[{A, B}] == result[{B, A}], so we only need to find
    # distances to nodes greater than the current one.
    locations = find_vals ( lines )
    locations.each do |from_val, from_coord|
        puts "Finding paths from #{from_val}..." if DEBUG
        # floodfill from here and keep track of numbers seen
        seen = Set(Tuple(Int32, Int32)).new
        boundary = [from_coord]
        distance = 0
        until boundary.empty?
            next_boundary = [] of Tuple(Int32, Int32)
            boundary.each do |row, col|
                next if seen.includes?({row, col})
                seen << {row, col}
                if lines[row][col].ascii_number?
                    puts "Found #{lines[row][col]}." if DEBUG
                    result[{from_val, lines[row][col].to_i}] = distance
                end
                [{-1,0}, {0,-1}, {1,0}, {0,1}].each do |dr, dc|
                    unless (lines[row+dr][col+dc] == '#')
                        (next_boundary << {row+dr, col+dc})
                    end
                end
            end
            puts "New boundary size is #{next_boundary.size}" if DEBUG
            boundary = next_boundary
            distance += 1
        end
    end
    return result
end

def traversal_length ( node_order, distances )
    total = 0
    node_order.each_cons_pair do |from_val, to_val|
        total += distances[{from_val, to_val}]
    end
    return total
end

def best_traversal ( start_val, return_to_start, distances )
    # 7! == only 5040, so we can probably brute-force this
    all_vals = distances.keys.reduce(Set(Int32).new) { |acc, pair|
            acc << pair[0] }.to_a
    all_vals.delete start_val
    best_distance = Int32::MAX
    all_vals.permutations.each do |suborder|
        order = [start_val] + suborder
        order << start_val if return_to_start
        distance = traversal_length ([start_val] + order), distances
        best_distance = distance if (distance < best_distance)
    end
    return best_distance
end

lines = File.read_lines "input24.txt"
puts "Building graph..." if DEBUG
graph = maze2graph lines
puts "Done." if DEBUG
puts graph if DEBUG

puts best_traversal 0, false, graph
puts best_traversal 0, true,  graph
