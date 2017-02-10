
class Mastermind
  attr_accessor :player, :board
  @@guesses = 12
  @@correct_code = 0
  @@correct_color = 0
  @@colors = ["red", "yellow", "green", "blue", "orange", "purple"]
  @@player_choice = 0
  @@total_guesses = []
  @@total_feedback = []


  def initialize
    
    puts "WELCOME TO MASTERMIND!!! \n\n\n You'll have to guess the secret color code of your opponent in 12 opportunities, by making a series of pattern guesses selecting from 6 colors: \n red, yellow, green, blue, orange, purple \n\n"
    puts "Please write your name"
    player_name = gets.chomp    
    @player = Player.new(player_name)
    game_choice

  end

  def game_choice
    puts "\n If you want to be the creator of the secret code type number 1, if you want to guess the code type number 2"
    @@player_choice = gets.chomp.to_i
      until @@player_choice == 1 || @@player_choice == 2
        puts "\n\n Please you have to type: \"1 to be code creator \" or \"2 to be code guesser\" to start the game."
        @@player_choice = gets.chomp.to_i
      end
    @board = Board.new(@@player_choice)
  end

  def start
    while !game_over?
      turn
      display_board
    end    
  end

  def turn
    puts"user choose #{@@player_choice}"
      if @@player_choice == 2
        user_turn
      else
        computer_logic
      end
  end

  def user_turn
    puts "Please #{@player.name} make your guess by typing 4 colors in the order you want"
    guessed_array = gets.chomp.downcase.split   
    until valid_colors?(guessed_array)
      puts "\nAt least one of your inputs is not valid, please type them again, separated by a single space, remeber you must type 4 valid colors between: \"red, yellow, green, blue, orange, purple\" \n "
      guessed_array = gets.chomp.downcase.split
    end
    @@total_guesses << guessed_array
    guess(guessed_array)     
  end

  def valid_colors?(guessed_array)
    is_valid = true
    array_length = guessed_array.length

    guessed_array.each do |guess| 
      if @@colors.include?(guess) 
        is_valid = true
      else
        is_valid = false
      end
    end

    is_valid = false if array_length != 4
     
    is_valid
  end

  def guess(guessed_array)

      right_guess = 0
      right_color = 0

      if  @@player_choice == 2
        puts "You select this combination #{guessed_array}"
      else
        puts "Computer player select this combination #{guessed_array}"
      end

       @board.color_code.each_with_index do | color, i |
        color_repetition = 0
        guessed_array.each_with_index do |guess, j|
          if guess == color
            color_repetition += 1
            if j == i 
              right_guess +=1 
            elsif @board.color_code[j] != guess && guessed_array[i] != color
              if color_repetition == 1
                right_color +=1
              end
            end
          end
        end
       end
    @@correct_code = right_guess
    @@correct_color = right_color
    feedback(right_guess, right_color)
    @@guesses -= 1
  end

  def computer_logic
    #if @@guesses == 12
      guessed_array = @@colors.sample(4)
      guess(guessed_array) 
  end

  def feedback(right_guess, right_color)
    feedback_array = ["Right guesses: #{right_guess}", "Right colors: #{right_color}"]
    @@total_feedback << feedback_array
  end

  def display_code
    puts board.color_code[0].to_s + " | " + board.color_code[1].to_s + " | " + board.color_code[2].to_s + " | " + board.color_code[3].to_s
  end

  def display_board
    puts "_________________________________________________________________________________________________________________"
    puts "This is the board"
    @@total_guesses.each_with_index do |guess, i| 
      print "\n" + "Guess #{i} " + " | "  + guess.to_s + " | " + "    Feedback: " + @@total_feedback[i].to_s +  " | " + "\n"
    end
    puts "__________________________________________________________________________________________________________________"
  end

  def game_over?

    if victory?
      puts "#{@player.name} WINS!!"
      return true      
    elsif no_guesses_left?
      puts "GAME OVER, NO GUESSES LEFT :( 
        \n the secret code was:"
      display_code
      return true
    else
      return false
    end
  end

  def victory?
    if @@correct_code == 4
      return true
    else
      return false
    end
  end

  def no_guesses_left?
    if @@guesses == 0
      return true
    else
      return false
    end
  end

  class Player
    attr_accessor :name
    
    def initialize(name)
      @name = name
    end
  end

  class Board
    attr_accessor :color_code
    attr_reader :player_choice

    @@colors = ["red", "yellow", "green", "blue", "orange", "purple"]

   
    def initialize(player_choice)
      if player_choice == 1 
        puts "user choose #{player_choice}"
        creator
      elsif player_choice == 2
        puts "user choose #{player_choice}"
        guesser
      end       
    end

    def creator
      puts "Please create your code by placing 4 colors (from red, yellow, green, blue, orange, purple) in the order you want, separate them by spaces"
      @color_code = gets.chomp.downcase.split
    end

    def guesser
       @color_code = []
        4.times { @color_code << @@colors.sample }
    end
  end
end

my_game = Mastermind.new
my_game.start