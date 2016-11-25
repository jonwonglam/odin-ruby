# Class to play the game tic-tac-toe
class TicTacToe

  # Scalable, can create a 3 or 6 player game
  SYMBOLS = ["X", "O"]
  PLAYERS = [1, 2]
  WINNING_PATTERNS = [
                      [[0,0], [0,1], [0,2]],
                      [[1,0], [1,1], [1,2]],
                      [[2,0], [2,1], [2,2]],
                      [[0,0], [1,0], [2,0]],
                      [[0,1], [1,1], [2,1]],
                      [[0,2], [1,2], [2,2]],
                      [[0,0], [1,1], [2,2]],
                      [[0,2], [1,1], [2,0]],
                     ]

  attr_accessor :board, :player_symbol, :finished, :current_player_index,
                :moves_left

  # Initialize the instance of the class
  def initialize
    @board = [["1", "2", "3"], ["4", "5", "6"], ["7", "8", "9"]]
    @current_player_index = 0
    @finished = false
    @moves_left = 9
    @game_over_msg = "Draw! "
  end

  # ----------------------
  # *** Public Methods ***
  # ----------------------
  public

  # Play a game of tic-tac-toe
  def play
    welcome
    until finished? do
      display_gameboard
      play_turn
    end
  end

  # -----------------------
  # *** PRIVATE METHODS ***
  # -----------------------
  private

  # Game logic to get user input, switch players, exit
  def play_turn
    choice = get_response_for "Player #{@current_player_index + 1}, enter a choice [1-9]"
    case choice
    when /^([1-9])$/
      if is_valid_choice?(choice.to_i)
        update_board(choice.to_i, SYMBOLS[current_player_index])
        change_players
        @moves_left -= 1
        game_over? ? restart? : nil
      else
        puts "Sorry that's already taken."
      end
    when "q"
      @finished = true
    when "help"
      instructions
    else
    end
  end

  def is_valid_choice?(pos)
    decision = true
    count = 0
    board.each do |row|
      row.each do |entry|
          count += 1
          (pos == count && (SYMBOLS.include? entry)) ? decision = false : 0
      end
    end
    decision
  end

  def update_board(pos, symbol)
    count = 0
    board.each do |row|
      row.map! do |entry|
          count += 1
          (pos == count) ? symbol : entry
      end
    end
  end

  def change_players
    @current_player_index < PLAYERS.length - 1 ? @current_player_index += 1 : @current_player_index = 0
  end

  def finished?
    @finished
  end

  def game_over?
    return true if moves_left == 0
    if check_for_winner
      @game_over_msg = "Player #{change_players + 1} wins! "
      return true
    end
    return false
  end

  def check_for_winner
    SYMBOLS.each do |symbol|
      WINNING_PATTERNS.each do |pattern|
        check = pattern.inject(0) do |is_valid, position|
          @board[position[0]][position[1]] != symbol ? is_valid : is_valid += 1
        end
        return true if check == 3
      end
    end
    false
  end

  def restart?
    display_gameboard
    print @game_over_msg
    loop do
      play_again = (get_response_for "Play again? (y/n)").downcase
      puts play_again
      case play_again
      when "y", "yes" then initialize; return
      when "n", "no" then @finished = true; return
      end
    end
  end

  def get_response_for(text)
    print text + ": "
    gets.chomp
  end

  def display_gameboard
    system "clear" or system "cls"

    board.each_with_index do |row, column_index|
      print_gameboard_row(row)
      print "\n"
      print_gameboard_seperator(column_index)
      print "\n"
    end
  end

  def print_gameboard_row(row)
    row.each_with_index do |entry, index|
      print " #{entry} "
      print "|" if index < board.length - 1
    end
  end

  def print_gameboard_seperator(column_index)
    if column_index < board.length - 1
      (0...board.length).each do |index|
        print "---"
        print "+" if index < board.length - 1
      end
    end
  end

  def welcome
    puts "Welcome to Ruby Tic-Tac-Toe"
    instructions
  end

  def instructions
    puts "Each player enters a number [1-9] on their turn"
    puts "The numbers correspond to the game board here:"
    puts " 1 | 2 | 3 "
    puts "---+---+---"
    puts " 4 | 5 | 6 "
    puts "---+---+---"
    puts " 7 | 8 | 9 "
    puts "You can exit this program by typing 'q'"
    puts "Show the instructions by typing 'help'"
    puts "Press enter to continue: "
    gets
    system "clear" or system "cls"
  end

# --------------------
# *** END of class ***
# --------------------
end

game = TicTacToe.new
game.play
