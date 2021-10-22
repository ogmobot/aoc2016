def build_whitelist ( blacklist )
    # Returns an array of allowed intervals
    whitelist = [ [UInt32::MIN, UInt32::MAX] ]
    blacklist.each do |interval_b|
        low_b, high_b = interval_b
        to_delete = [] of Int32 # list of indices (must be in descending order)
        new_intervals = [] of Array(UInt32)
        whitelist.each_with_index do |interval_w, i|
            low_w, high_w = interval_w
            # It's inefficient not to keep these in order, but w/e
            if ((low_b > high_w) || (high_b < low_w))
                # no overlap
            elsif ((low_b <= low_w) && (high_b >= high_w))
                # covers
                to_delete.unshift(i)
            elsif ((low_b > low_w) && (high_b < high_w))
                # sits inside
                to_delete.unshift(i)
                new_intervals << [low_w, low_b - 1]
                new_intervals << [high_b + 1, high_w]
            elsif low_w < low_b
                # high end of white interval overlaps
                interval_w[1] = low_b - 1
            elsif high_w > high_b
                # low end of white interval overlaps
                interval_w[0] = high_b + 1
            else
                # should never happen
                puts "UNDEFINED CASE"
                puts "interval_w=#{interval_w}"
                puts "interval_b=#{interval_b}"
            end
        end
        to_delete.each do |i| whitelist.delete_at i end
        whitelist = whitelist + new_intervals
    end
    return whitelist
end

blacklist = ( File.read_lines "input20.txt" ).map { |line|
    (line.split "-").map { |s|
        s.to_u32
    }
}

whitelist = build_whitelist blacklist
puts whitelist.map{|pair| pair[1]}.min
puts whitelist.map{|pair| pair[1] - pair[0] + 1}.sum
