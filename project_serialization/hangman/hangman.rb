# Hangman.rb -- Hangman game written in Ruby
require 'json'

class Hangman
  attr_accessor :word, :player_work, :chars_guessed, :guesses_left

  def initialize
    word_list = File.readlines '5desk.txt'

    @word = choose_word(word_list).downcase
    @player_work = convert_to_blank_char_array(@word)
    @chars_guessed = []
    @guesses_left = 6
    @game_finished = false
  end

  def to_json
    hash = {}
    self.instance_variables.each do |var|
      hash[var] = self.instance_variable_get var
    end
    hash.to_json
  end

  def from_json(string)
    data = JSON.parse(string)
    @word = data['@word']
    @player_work = data['@player_work']
    @chars_guessed = data['@chars_guessed']
    @guesses_left = data['@guesses_left']
  end

  def save_game
    File.open("save_game.json", "w") do |file|
      file.puts to_json
    end
  end

  def load_game
    from_json File.read("save_game.json")
  end

  # Choose a word randomly from a list, 5-12 chars long
  def choose_word(word_list)
    acceptable_words = word_list.select{ |word| word.length > 4 && word.length < 13 }
    word = acceptable_words[Random.rand(acceptable_words.length)].strip
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
    start_from_file = get_response_for("Load game? (y/n)").downcase
    load_game if start_from_file ==  "y"

    until @game_finished do
      display_work

      guess = get_valid_guess

      char_exists = check_word_for_char(guess)

      print_feedback(char_exists, guess)

      char_exists ? update_work(guess) : @guesses_left -= 1

      @game_finished = check_if_game_over

      save_game
    end
  end
end

hangman = Hangman.new
hangman.start_game
