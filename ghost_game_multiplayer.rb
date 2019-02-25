require "set"
require "byebug"
require_relative "player"

class GhostGame
    attr_reader :players, :dictionary, :losses
    attr_accessor :fragment

    def initialize(*names)
        @players = []
        names.each { |name| @players << Player.new(name) }

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
            puts " "
             puts "-----------------------"
                puts "It's #{current_player.name}'s turn!'"
                puts " "
            self.take_turn
            self.next_player!
            if @dictionary.include?(@fragment) #should this be moved elsewhere?
                puts "***********************"
                puts "Round over! #{previous_player.name} spelled #{fragment}!"
                @losses[previous_player.name] += 1 
                self.check_loser
                puts " "
                self.display_standing
                @fragment = ""
                play = false
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

    def delete_player(player_name) #needs to be tested
        @players.each_with_index do |player, i| 
            if player.name == player_name
                @players.delete_at(i)
            end
        end   

        @losses.delete(player_name)
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
        until @players.length == 1
            self.play_round
        end

        puts "#{current_player.name} has won!"
        puts "GAME OVER!"
    end

    def display_standing
        @players.each { |player| puts "#{player.name}'s score is: #{record(player.name)}" }
    end

    def check_loser
        @players.each do |player|
            if @losses[player.name] == 5
                puts " "
                puts "!!!!!!!!!!!"
                puts "#{player.name} spelled GHOST! They're out!"
                puts "!!!!!!!!!!!"
                puts " "
                delete_player(player.name)
            end
        end
    end

end

if __FILE__== $PROGRAM_NAME
    puts "How many players? "
    player_names = []
    player_num = gets.chomp.to_i
    player_count = 1

    player_num.times do
        puts "Player #{player_count}'s name:"
        player_name = gets.chomp
        player_names << player_name
        player_count += 1
    end

    ghost_game = GhostGame.new(*player_names)
    ghost_game.run
end

