require 'colored'

module Rings
  class Logger    
    def initialize out
      @out = out
    end

    def info message
      @out.puts "#{"[info]".blue} #{message}"
    end

    def warn message
      @out.puts "#{"[warn]".yellow} #{message}"
    end

    def error message      
      @out.puts "#{"[error]".red} #{message}"
    end
  end
end
