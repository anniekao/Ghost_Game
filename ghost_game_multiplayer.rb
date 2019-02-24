require "set"
require "byebug"
require_relative "player"

class GhostGame
    attr_reader :players, :dictionary, :losses
    attr_accessor :fragment

    def initialize(*names)
        @players = []
        names.each { |name| @players << Player.new(name)}

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
            if @dictionary.include?(@fragment) #should this be moved elsewhere?
                puts "***********************"
                puts "Round over! #{previous_player.name} spelled #{fragment}! They're out!"
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

    def delete_player(player) #needs to be tested
        @players.delete(player)
        @losses.delete(player)
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

    def run #needs to be updated for multiplayer
        until @losses[current_player.name] == 5 || @losses[previous_player.name] == 5
            self.play_round
        end

        #delete the loser from the players array here?
        puts "#{winner} has won!"
        puts "GAME OVER!"
    end

    def display_standing
        @players.each { |player| puts "#{player.name} score is: " }
    end

    def winner #needs to be updated for multiplayer         
        return current_player.name if @losses[current_player.name] < 5
        return previous_player.name if @losses[previous_player.name] < 5
    end
end

ghost = GhostGame.new("James", "Paul", "Anna", "Amy")
p ghost.record("James")