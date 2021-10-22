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
            @regs[instr[2][0]] = if "abcd".includes? instr[1]
                @regs[instr[1][0]]
            else
                instr[1].to_i
            end
        elsif instr[0] == "inc"
            @regs[instr[1][0]] += 1
        elsif instr[0] == "dec"
            @regs[instr[1][0]] -= 1
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
end

lines = File.read_lines "input12.txt"
cpu = Cpu.new(lines)
cpu.run
puts cpu.to_s
cpu = Cpu.new(lines)
cpu.setregs({'c'=>1})
cpu.run
puts cpu.to_s
