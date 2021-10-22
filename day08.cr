require "bit_array"
GRID_HEIGHT = 6
GRID_WIDTH = 50

lines = File.read_lines "input08.txt"

def mutate_matrix (line, grid)
    rect = /rect (?<width>[0-9]+)x(?<height>[0-9]+)/.match(line)
    row  = /rotate row y=(?<y>[0-9]+) by (?<val>[0-9]+)/.match(line)
    col  = /rotate column x=(?<x>[0-9]+) by (?<val>[0-9]+)/.match(line)
    if rect
        (0...(rect.["height"].to_i)).each do |y|
            (0...(rect.["width"].to_i)).each do |x|
                grid[y][x] = true
            end
        end
    elsif row
        result_row = BitArray.new(GRID_WIDTH)
        (0...GRID_WIDTH).each do |index|
            result_row[ (index + row.["val"].to_i) % GRID_WIDTH ] =
                grid[ row.["y"].to_i ][ index ]
        end
        grid[ row.["y"].to_i ] = result_row
    elsif col
        result_col = BitArray.new(GRID_HEIGHT)
        (0...GRID_HEIGHT).each do |index|
            result_col[ (index + col.["val"].to_i) % GRID_HEIGHT ] =
                grid[ index ] [ col.["x"].to_i ]
        end
        (0...GRID_HEIGHT).each do |index|
            grid[ index ][ col.["x"].to_i ] = result_col[ index ]
        end
    else
        puts "WARNING - malformed line \"#{line}\""
    end
end

grid = [] of BitArray
(1..GRID_HEIGHT).each do grid << BitArray.new(GRID_WIDTH) end

lines.each do |line|
    mutate_matrix line, grid
end
puts grid.map { |row| row.count(true) }.sum
grid.each do |row| puts row.map { |b| {true=>'@', false=>' '}[b] }.join end
