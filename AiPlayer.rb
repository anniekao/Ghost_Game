require_relative "ghost_game_multiplayer"

class AiPlayer
    attr_reader :num_players, :fragment, :dictionary

    def initialize(num_players, fragment, dictionary)
        @num_players = num_players
        @fragment = fragment 
        @dictionary = dictionary       
    end    

    def winning_move
        #decides if adding a letter to a fragment results in only words with letters <= num_players
    end

    def losing_move
        #decides if adding a letter to a fragment will spell a word
    end

    def decide_move
        #decides if a move will be a winning or losing move
        #if a winning move is possible take it
        #if no winning moves are possible then randomly choose a losing move
    end

    # add method that computes the entire tree of possible moves from current fragment 
    # it should leave the least number of losing moves and the most winning moves
end