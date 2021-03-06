require "set"
require "byebug"
require_relative "player"

class GhostGame
    attr_reader :player1, :player2, :players, :dictionary, :losses
    attr_accessor :fragment

    def initialize(*names)
        @player1 = Player.new(names[0])
        @player2 = Player.new(names[1])
        @players = [@player1, @player2]
        @fragment = ""
        
        words = File.readlines("dictionary.txt")
        words.each_with_index do |word, i|
            words[i] = word.chomp
        end

        @dictionary = Set.new(words)
        @losses = Hash.new(0)
        @players.each { |player| @losses[player.name] = 0}
    end 

    def play_round
        play = true
        while play
             puts "-----------------------"
                puts "It's #{current_player.name}'s turn!'"
                puts " "
            self.take_turn
            self.next_player!
            if @dictionary.include?(@fragment)
                puts "***********************"
                puts "Round over! #{previous_player.name} spelled #{fragment}!"
                @losses[previous_player.name] += 1
                puts " "
                self.display_standing
                @fragment = ""
                play = false
            else
                puts "-----------------------"
                puts "It's #{current_player.name}'s turn!'"
                puts " "
            end
        end
    end

    def current_player
        @players.first
    end
    
    def previous_player
        @players.last
    end

    def next_player!
        @players = @players.rotate
    end

    def take_turn
        valid = false
    
        until valid 
            guess = current_player.guess
            if valid_play?(guess)
                puts "That's a valid guess."
                @fragment += guess
                valid = true
            else
                current_player.alert_invalid_guess
            end
        end
    end

    def valid_play?(guess)
        alphabet = Set.new("a".."z")
        possible_fragment = @fragment + guess

        return false if !alphabet.include?(guess) || !dictionary.any? { |word| word.start_with?(possible_fragment)}
        true
    end

    def record(player)
        score_strings = {0 => "You haven't lost yet!", 1 => "G", 2 => "GH", 3 => "GHO", 4 => "GHOS", 5=> "GHOST"}
        losses_score = losses[player]
        score_strings[losses_score]
    end

    def run
        until @losses[current_player.name] == 5 || @losses[previous_player.name] == 5
            self.play_round
        end
        puts "#{winner} has won!"
        puts "GAME OVER!"
    end

    def display_standing
        puts "#{player1.name}'s score: #{record(player1.name)}"
        puts "#{player2.name}'s score: #{record(player2.name)}"
    end

    def winner
        return current_player.name if @losses[current_player.name] < 5
        return previous_player.name if @losses[previous_player.name] < 5
    end
end

ghost = GhostGame.new("James", "Paul")
ghost.run