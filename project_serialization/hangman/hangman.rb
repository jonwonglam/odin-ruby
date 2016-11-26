# Hangman.rb -- Hangman game written in Ruby

class Hangman

  def initialize
    word_list = File.readlines '5desk.txt'

    @word = choose_word(word_list).downcase
    puts @word
    @player_work = convert_to_blank_char_array(@word)
    @chars_guessed = []
    @guesses_left = 6
    @game_finished = false
  end

  # Choose a word randomly from a list, 5-12 chars long
  def choose_word(word_list)
    acceptable_words = word_list.select{ |word| word.length > 4 && word.length < 13 }
    word = acceptable_words[Random.rand(acceptable_words.length)]
  end

  # Converts a string into an array of '_' chars
  def convert_to_blank_char_array(string)
    char_array = string.scan(/\w/)
    char_array.map! { |i| '_' }
  end

  # Print the work, chars guessed, and number of guesses left
  def display_work
    puts "\n" + @player_work.join(' ')
    puts "Letters guessed: #{@chars_guessed.join(' ')}| Guesses left: #{@guesses_left}"
  end

  # Helper function: displays text and returns user's input to text
  def get_response_for(text)
    print text
    gets.chomp
  end

  # Loop until user enters a valid guess using 'check_if_valid_guess'
  # Adds guess to @chars_guessed and returns the char
  def get_valid_guess(valid = false)
    until valid do
      guess = get_response_for("Guess a letter: ").downcase;
      valid = check_if_valid(guess)
    end

    @chars_guessed << guess
    guess
  end

  # Helper Function: checks that the guess is a char and
  # hasn't been guessed already
  def check_if_valid(guess)
    case guess
    when -> (guess) { !guess.match(/^[A-z]$/) } then
      puts "Sorry, that's not a valid guess"; false
    when -> (guess) { @chars_guessed.include?(guess) } then
      puts "You already guessed '#{guess}'"; false
    else
      true
    end
  end

  # Returns whether the char exists in the word
  def check_word_for_char(char)
    @word.include?(char) ? true : false
  end

  # Prints feedback based on if the letter exists in the word
  def print_feedback(char_exists, guess)
    puts char_exists ? "That's a hit!" : "Sorry, '#{guess}' is not in the word."
  end

  # Replaces underscores with char in player_work for all occurances
  def update_work(guess)
    @word.split("").each_with_index do |c, index|
      @player_work[index] = guess if c == guess
    end
  end

  # Checks if player guessed the word or ran out of guesses
  def check_if_game_over
    if @guesses_left == 0
      puts "Game over, you ran out of guesses!"
      true
    elsif all_letters_guessed?
      puts "Great job, you guessed the word!"
      true
    else
      false
    end
  end

  # Helper Function: Returns true if all underscores are guessed
  def all_letters_guessed?
    word_guessed = true
    @player_work.each { |c| word_guessed = false if c == '_' }
    word_guessed
  end

  # Call this to start the game logic
  def start_game
    until @game_finished do
      display_work

      guess = get_valid_guess

      char_exists = check_word_for_char(guess)

      print_feedback(char_exists, guess)

      char_exists ? update_work(guess) : @guesses_left -= 1

      @game_finished = check_if_game_over
    end
  end
end

hangman = Hangman.new
hangman.start_game
