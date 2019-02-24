class Player
    attr_reader :name
    def initialize(name)
        @name = name
    end

    def guess
        puts "Please enter a letter: "
        guess = gets.chomp
        guess
    end

    def alert_invalid_guess
        puts "#{name}, you entered an invalid guess. Try again!"
    end
end

