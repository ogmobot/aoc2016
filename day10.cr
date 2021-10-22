class Robot
    @id          : UInt8
    @left_val    : Nil | UInt8
    @right_val   : Nil | UInt8
    @low_target  : Robot | OutputBin
    @high_target : Robot | OutputBin
    def initialize (id : UInt8)
        @id          = id
        @left_val    = nil
        @right_val   = nil
        @low_target  = OutputBin.new
        @high_target = OutputBin.new
    end

    def set_lohi (low : Robot | OutputBin, high : Robot | OutputBin)
        @low_target = low
        @high_target = high
    end

    def give (val : UInt8)
        if @left_val.nil?
            @left_val = val
        else
            @right_val = val
            self.log_vals
            if (@high_target != self && @low_target != self)
                if safe(@left_val) < safe(@right_val)
                    @low_target.give safe(@left_val)
                    @high_target.give safe(@right_val)
                else
                    @high_target.give safe(@left_val)
                    @low_target.give safe(@right_val)
                end
            end
        end
    end

    def log_vals ()
        if (@left_val == 61 && @right_val == 17 || @left_val == 17 && @right_val == 61)
            puts "BEEP BOOP. I AM BOT #{@id} AND I COMPARE 17 AND 61."
        end
    end
end

class OutputBin
    @val : Nil | UInt8
    def initialize ()
        @val = nil
    end

    def give (val : UInt8)
        @val = val
    end

    def val
        safe(@val)
    end
end

def safe (val : UInt8 | Nil)
    if val
        return val
    else
        return 0.to_u8
    end
end

robots = Array.new(256) { |i| Robot.new(i.to_u8) }
bins   = Array.new(256) { OutputBin.new }

lines = File.read_lines "input10.txt"

# first pass: configure robots
lines.each do |line|
    if m = /bot (?<id>[0-9]+) gives low to (?<low_class>bot|output) (?<low>[0-9]+) and high to (?<high_class>bot|output) (?<high>[0-9]+)/.match line
        robot = robots[m.["id"].to_i]
        low_target = if m.["low_class"] == "bot"
            robots[m.["low"].to_i]
        else
            bins[m.["low"].to_i]
        end
        high_target = if m.["high_class"] == "bot"
            robots[m.["high"].to_i]
        else
            bins[m.["high"].to_i]
        end
        robot.set_lohi low_target, high_target
    end
end

# second pass: distribute values to robots
lines.each do |line|
    if m = /value (?<val>[0-9]+) goes to bot (?<id>[0-9]+)/.match line
        robots[m.["id"].to_i].give m.["val"].to_i.to_u8
    end
end

puts bins[0..2].reduce(1) { |acc, bin| bin.val.to_i32 * acc }
