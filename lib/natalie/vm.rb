module Natalie
  class VM
    def initialize(instructions)
      @instructions = instructions
      @stack = []
      @self = Object.new # FIXME: should 'main'
    end

    attr_accessor :self

    def run
      @instructions.each do |instruction|
        instruction.execute(self)
      end
    end

    def push(object)
      @stack.push(object)
    end

    def pop
      @stack.pop
    end
  end
end
