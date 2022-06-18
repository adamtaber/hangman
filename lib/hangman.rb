require 'yaml'

class Hangman
  @@dictionary = ''
  def initialize
    @computer_word = ''
    @player_guess = ''
    @incorrect_letters = ''
    @correct_letters = []
    @player_penalty_points = 0
    @game_over = false
    @turn_number = 0
    @save = ''
  end

  def create_dictionary
    raw_dictionary = File.readlines('google-10000-english-no-swears.txt', chomp: true)
    dictionary = raw_dictionary.map do |word|
      if word.length >= 5 && word.length <= 12
        word
      end
    end
    @@dictionary = dictionary
  end

  def generate_random_word
    @computer_word = @@dictionary.sample
    if @computer_word.nil?
      generate_random_word
    else
      @computer_word
      @computer_word = @computer_word.split('')
    end
  end

  def generate_correct_letters
    for i in (1..@computer_word.length) do
      @correct_letters.push("_ ")
    end
  end

  def generate_incorrect_letters
    @incorrect_letters = "incorrect letters: "
  end

  def generate_intro
    puts "Welcome to Hangman!"
    if Dir.exists?('save_files')
      files = Dir.entries('save_files')
      files.each_index do |index|
        puts "#{index}: #{files[index]}"
      end
      puts "type the number of the save file you would like to load"
      number = gets.chomp.to_i

      yaml = YAML.load_file("save_files/#{files[number]}")

      File.open("save_files/#{files[number]}", 'r') do |file|
        file
      end
    end
  end

  def save_game
    yaml_hash = {"computer_word" => @computer_word, "player_guess" => @player_guess,
      "incorrect_letters" => @incorrect_letters, "correct_letters" => @correct_letters,
      "player_penalty_points" => @player_penalty_points, "game_over" => @game_over, 
      "turn_number" => @turn_number}
    Dir.mkdir('save_files') unless Dir.exists?('save_files')
    puts "type name"
    file_name = gets.chomp
    File.open("save_files/#{file_name}.yaml", "w") do |file|
        file.puts YAML.dump(yaml_hash)
    end
    puts "Your game has been saved, thank you playing"
    game_over = true
  end

  def get_player_guess
    puts "\n"
    puts "Please enter a letter or the full word you think you've solved it"
    puts "If you would like to save your game, type '1' and press enter"
    @player_guess = gets.chomp.downcase
    if @player_guess == '1'
      save_game
    elsif @player_guess.gsub(/[^a-z]/i, '').length != @player_guess.length
      puts "\n"
      puts "That input is not valid \n"
      get_player_guess
    end
  end

  def draw_hangman
    yaml_hash = {"computer_word" => @computer_word, "player_guess" => @player_guess,
    "incorrect_letters" => @incorrect_letters, "correct_letters" => @correct_letters,
    "player_penalty_points" => @player_penalty_points, "game_over" => @game_over, 
    "turn_number" => @turn_number}
    puts YAML.dump(yaml_hash)

    if @player_penalty_points == 0
      puts "____________"
      puts "|"
      puts "|"
      puts "|"
      puts "|"
      puts "|"
      puts "|"
      puts "\n"
      puts @correct_letters.join
      puts "\n"
      puts @incorrect_letters
      puts "\n"
    elsif @player_penalty_points == 1
      puts "____________"
      puts "|"
      puts "|          O"
      puts "|"
      puts "|"
      puts "|"
      puts "|"
      puts "\n"
      puts @correct_letters.join
      puts "\n"
      puts @incorrect_letters
      puts "\n"
    elsif @player_penalty_points == 2
      puts "____________"
      puts "|"
      puts "|          O"
      puts "|          |"
      puts "|"
      puts "|"
      puts "|"
      puts "\n"
      puts @correct_letters.join
      puts "\n"
      puts @incorrect_letters
      puts "\n"
    elsif @player_penalty_points == 3
      puts "____________"
      puts "|"
      puts "|          O"
      puts "|         /|"
      puts "|"
      puts "|"
      puts "|"
      puts "\n"
      puts @correct_letters.join
      puts "\n"
      puts @incorrect_letters
      puts "\n"
    elsif @player_penalty_points == 4
      puts "____________"
      puts "|"
      puts "|          O"
      puts "|         /|\\"
      puts "|"
      puts "|"
      puts "|"
      puts "\n"
      puts @correct_letters.join
      puts "\n"
      puts @incorrect_letters
      puts "\n"
    elsif @player_penalty_points == 5
      puts "____________"
      puts "|"
      puts "|          O"
      puts "|         /|\\"
      puts "|         /"
      puts "|"
      puts "|"
      puts "\n"
      puts @correct_letters.join
      puts "\n"
      puts @incorrect_letters
      puts "\n"
    elsif @player_penalty_points == 6
      puts "____________"
      puts "|"
      puts "|          O"
      puts "|         /|\\"
      puts "|         / \\"
      puts "|"
      puts "|"
      puts "\n"
      puts @correct_letters.join
      puts "\n"
      puts @incorrect_letters
      puts "\n"
    elsif @player_penalty_points == 7
      puts "____________"
      puts "|          |"
      puts "|          O"
      puts "|         /|\\"
      puts "|         / \\"
      puts "|"
      puts "|"
      puts "\n"
      puts @correct_letters.join
      puts "\n"
      puts @incorrect_letters
      puts "\n"
      @game_over = true
      puts "Sorry, you lose. The correct word was #{@computer_word.join}"
    end
  end

  def player_letter_correct?
    if @computer_word.join.include?(@player_guess)
      @computer_word.each_index do |index|
        if @computer_word[index] == @player_guess
          @correct_letters[index].replace("#{@player_guess} ")
        end
      end
      draw_hangman
      if @correct_letters.include?("_ ") == false
        puts "Congratulations, you win! The word was #{@computer_word.join}\n"
        @game_over = true
      end
    else
      @incorrect_letters.insert(-1, "#{@player_guess}, ")
      @player_penalty_points += 1
      draw_hangman
    end
  end

  def player_word_correct?
    if @computer_word.join == @player_guess
      @computer_word.each_index do |index|
        if @computer_word[index] == @player_guess.split("")[index]
          @correct_letters[index].replace("#{@player_guess.split("")[index]} ")
        end
      end
      draw_hangman
      puts "Congratulations, you win! The word was #{@computer_word.join}\n"
      @game_over = true
    else
      @player_penalty_points += 1
      draw_hangman
    end
  end

  def checks_letter_or_word
    if @player_guess.length == 1
      player_letter_correct?
    else
      player_word_correct?
    end
  end

  def game_over?
    if @game_over == false
      play_game
    elsif @game_over == true
      play_again?
    end
  end

  def play_again?
    puts "Would you like to play again? (y/n)"
    play_again = gets.chomp.downcase
    if play_again == "y"
      @turn_number = 0
      @player_penalty_points = 0
      play_game
    else
      puts "Thank you playing! Goodbye"
    end
  end

  def play_game
    if @turn_number == 0
      @turn_number += 1
      create_dictionary
      generate_random_word
      generate_correct_letters
      generate_incorrect_letters
      puts @correct_letters.join
      get_player_guess
      checks_letter_or_word
      game_over?
    else
      @turn_number += 1
      get_player_guess
      checks_letter_or_word
      game_over?
    end
  end
end

new_game = Hangman.new

new_game.generate_intro
new_game.play_game

#creating a save file
#press 1 to save game
#type name of save_file
#create new file with instance of hangman class
#on game startup, give option to load save_file
#if they choose yes, show list of savefiles each assigned to a number
#allow user to type number to select save file
#selecting saving file will load the instance data