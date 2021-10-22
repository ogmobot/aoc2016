class Node
    property size, used, avail, usepc
    def initialize ( @size : Int32, @used : Int32, @avail : Int32, @usepc : Int32 )
    end

    def empty? ()
        return @avail >= 70
    end
    def wall? ()
        return @used >= 300
    end
end

def parse_line ( line )
    if m = /node\-x(?<x>[0-9]+)\-y(?<y>[0-9]+) (?<data>.*)$/.match line
        x = m.["x"].to_i
        y = m.["y"].to_i
        size, used, avail, usepc = m.["data"]
            .strip
            .split
            .map{ |n| n.rchop.to_i }
        return { {x, y}, Node.new(size, used, avail, usepc) }
    else
        return { {0, 0}, nil }
    end
end

def count_viable_pairs ( ht )
    total = 0
    ht.each do |coord, node_A|
        ht.each do |coord, node_B|
            next if node_A == node_B
            next if node_A.used == 0
            next if node_A.used > node_B.avail
            total += 1
        end
    end
    return total
end

def display_nodes ( ht )
    min_x, max_x = ht.keys.minmax_of { |k| k[0] }
    min_y, max_y = ht.keys.minmax_of { |k| k[1] }
    (min_y .. max_y).each do |y|
        buffer = ""
        (min_x .. max_x).each do |x|
            node = ht[{x, y}]
            #buffer = buffer + " #{node.used}/#{node.size}"
            #buffer = buffer + " #{node.avail}"
            if node.empty?
                buffer = buffer + " _"
            elsif node.wall?
                buffer = buffer + " #"
            else
                buffer = buffer + " ."
            end
        end
        puts buffer
    end
end

def end_of_wall ( ht )
    # finds the {x, y} that the empty cell must move to before going to
    # the top-right cell
    min_x, max_x = ht.keys.minmax_of { |k| k[0] }
    wall_nodes = ht.select { |k, v| v.wall? }
    wall_y = wall_nodes.first_key[1]
    min_wall, max_wall = wall_nodes.keys.minmax_of { |k| k[0] }
    if min_x == min_wall
        return {max_wall+1, wall_y}
    else
        return {min_wall-1, wall_y}
    end
end
def almost_top_right ( ht )
    # finds the {x, y} of the cell just left of the top-right cell
    return {(ht.keys.max_of { |k| k[0] })-1, 0}
end
def manhattan ( coord_a, coord_b )
    return (coord_a[0]-coord_b[0]).abs + (coord_a[1]-coord_b[1]).abs
end

lines = (File.read_lines "input22.txt")[2..]
nodes = Hash(Tuple(Int32, Int32), Node).new
lines.each do |line|
    coord, node = parse_line line
    (nodes[coord] = node) if node
end

# part 1
puts count_viable_pairs nodes

# part 2
#display_nodes nodes
starting_point = nodes.select { |k, v| v.empty? }.first_key
checkpoint = end_of_wall nodes
wiggle_start = almost_top_right nodes
# wiggle pattern: 5 steps
# . _ G  =>  . G _  =>  . G .  =>  . G .  =>  . G .  =>  _ G .
# . . .      . . .      . . _      . _ .      _ . .      . . .
total = 0
total += (manhattan starting_point, checkpoint) # move gap around wall
total += (manhattan checkpoint, wiggle_start) # move gap to target data
total += 5 * (manhattan wiggle_start, {0, 0}) # move gap to {0, 0}
                                              # (each wiggle takes 5 steps)
total += 1 # swap gap from {0, 0} into {1, 0}, where the target data is
puts total
