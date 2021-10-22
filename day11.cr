# represent microchips/generators as {enum element, bool is_rtg, UInt8 loc}

enum Element
    Sr
    Pu
    Tl
    Ru
    Cm
    El
    Di
end

def build_state ( lines )
    elements = {
        "strontium" => Element::Sr,
        "plutonium" => Element::Pu,
        "thulium"   => Element::Tl,
        "ruthenium" => Element::Ru,
        "curium"    => Element::Cm,
    }
    state = [] of Tuple(Element, Bool, Int32)
    (1..lines.size).each do |floor|
        lines[floor-1].scan(/(?<element>[a-z]*) generator/).each do |m|
            state << {elements[m.["element"]], true, floor}
        end
        lines[floor-1].scan(/(?<element>[a-z]*)\-compatible/).each do |m|
            state << {elements[m.["element"]], false, floor}
        end
    end
    return state
end

def allowed_state? (state : Array(Tuple(Element, Bool, Int32)))
    #puts "Evaluating state=#{state}"
    # find chips that are separated from their rtgs, then return false iff
    # there are any other rtgs on the same floor
    state.select { |item| item[1] == false }.each do |chip|
        #puts "Checking chip = #{chip}"
        if !state.includes? ({chip[0], true, chip[2]})
            if state.any? { |item|
                item[2] == chip[2] && item[1] && item[0] != chip[0] }
                return false
            end
        end
    end
    return true
end

def winning_state? ( state )
    return state.all? { |item| item[2] == 4 }
end

def uni_hash ( universe )
    # if it's stupid, but it works, it's not stupid.
    state = universe[0]
    return (
        universe[1] +
        (8**1) * state.count { |item|  item[1] && item[2] == 0 } +
        (8**2) * state.count { |item| !item[1] && item[2] == 0 } +
        (8**3) * state.count { |item|  item[1] && item[2] == 1 } +
        (8**4) * state.count { |item| !item[1] && item[2] == 1 } +
        (8**5) * state.count { |item|  item[1] && item[2] == 2 } +
        (8**6) * state.count { |item| !item[1] && item[2] == 2 } +
        (8**7) * state.count { |item|  item[1] && item[2] == 3 } +
        (8**8) * state.count { |item| !item[1] && item[2] == 3 }
    )
end

def next_universes ( state, floor, time )
    possible_unis = [] of Tuple(Array(Tuple(Element, Bool, Int32)), Int32, Int32)

    state.select { |item| item[2] == floor }.each_combination(2) do |combo|
        new_state_up = state.select { |item| !combo.includes? item }
        new_state_down = new_state_up.dup
        combo.each do |item|
            new_state_up << {item[0], item[1], item[2] + 1}
            new_state_down << {item[0], item[1], item[2] - 1}
        end
        if floor < 4 && allowed_state? new_state_up
            possible_unis << {new_state_up, floor + 1, time + 1}
        end
        if floor > 1 && allowed_state? new_state_down
            possible_unis << {new_state_down, floor - 1, time + 1}
        end
    end

    state.select { |item| item[2] == floor }.each do |single|
        new_state_up = state.select { |item| item != single }
        new_state_down = new_state_up.dup
        new_state_up << {single[0], single[1], single[2] + 1}
        new_state_down << {single[0], single[1], single[2] - 1}
        if floor < 4 && allowed_state? new_state_up
            possible_unis << {new_state_up, floor + 1, time + 1}
        end
        if floor > 1 && allowed_state? new_state_down
            possible_unis << {new_state_down, floor - 1, time + 1}
        end
    end
    #puts "Possible unis=#{possible_unis}"
    return possible_unis
end

def solve ( initial_state )
    # a universe is state, floor, time
    universe = {initial_state, 1, 0}
    universes = [universe]
    seen = Set(Int32).new
    seen << uni_hash(universe)
    loop do
        universe = universes.shift
        break if winning_state? universe[0]
        break if universes.size > 1000
        next_universes( *universe ).each do |u|
            if !seen.includes? uni_hash(u)
                universes << u
                seen << uni_hash(u)
            end
        end
        #puts universes
    end

    if !winning_state? universe[0]
        puts "Search space too large -- program terminated!"
    end
    return universe
end

input = File.read_lines "input11.txt"

state = build_state input

puts (solve state )[2]

# Extra RTG and Chips
state << {Element::Di,  true, 1}
state << {Element::Di, false, 1}
state << {Element::El,  true, 1}
state << {Element::El, false, 1}

puts (solve state )[2]
