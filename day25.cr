DEBUG = false

class Cpu
    def initialize ( program : Array(String) )
        @program = program
        @regs = {
            'a' => 0,
            'b' => 0,
            'c' => 0,
            'd' => 0,
        }
        @ip = 0
        @outbuffer = [] of Int32
    end
    def setregs ( regs = Hash(Char, Int32) )
        @regs.merge! regs
    end
    def step ()
        instr = @program[@ip].split
        if DEBUG
            puts instr
        end
        if instr[0] == "cpy"
            if "abcd".includes? instr[2]
                @regs[instr[2][0]] = if "abcd".includes? instr[1]
                    @regs[instr[1][0]]
                else
                    instr[1].to_i
                end
            end
        elsif instr[0] == "inc"
            if "abcd".includes? instr[1]
                @regs[instr[1][0]] += 1
            end
        elsif instr[0] == "dec"
            if "abcd".includes? instr[1]
                @regs[instr[1][0]] -= 1
            end
        elsif instr[0] == "jnz"
            x = if "abcd".includes? instr[1]
                @regs[instr[1][0]]
            else
                instr[1].to_i
            end
            if x != 0
                target = if "abcd".includes? instr[2]
                    @ip + @regs[instr[2][0]]
                else
                    @ip + instr[2].to_i
                end
                @ip = target - 1 # it will be incremented later
            end
        elsif instr[0] == "tgl"
            target = if "abcd".includes? instr[1]
                @ip + @regs[instr[1][0]]
            else
                @ip + instr[1].to_i
            end
            if target < @program.size
                old_command = @program[target].split
                if old_command.size == 2 # one-argument command
                    if old_command[0] == "inc"
                        new_command = "dec #{old_command[1]}"
                    else
                        new_command = "inc #{old_command[1]}"
                    end
                else # two-argument command
                    if old_command[0] == "jnz"
                        new_command = "cpy #{old_command[1..].join ' '}"
                    else
                        new_command = "jnz #{old_command[1..].join ' '}"
                    end
                end
                @program[target] = new_command
            end
        elsif instr[0] == "out"
            val = if "abcd".includes? instr[1]
                @regs[instr[1][0]]
            else
                instr[1].to_i
            end
            @outbuffer << val
        end
        @ip += 1
    end
    def to_s ()
        return "Cpu: a=#{@regs['a']} b=#{@regs['b']} c=#{@regs['c']} d=#{@regs['d']} ip=#{@ip}"
    end
    def run ()
        while @ip < @program.size
            self.step
        end
    end
    def fill_buffer_to_size (n)
        while (@ip < @program.size && @outbuffer.size < n)
            self.step
        end
        return @outbuffer
    end
end

lines = File.read_lines "input25.txt"
(0..).each do |val|
    puts "Testing #{val}..." if DEBUG
    cpu = Cpu.new(lines)
    cpu.setregs({'a'=>val})
    check = cpu.fill_buffer_to_size 8 # or higher
    temp = true
    check.each_with_index do |val, i|
        if (i % 2) != val
            temp = false
            break
        end
    end
    if temp
        puts val
        break
    end
end
