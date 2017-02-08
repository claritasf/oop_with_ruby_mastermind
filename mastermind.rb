class Mastermind
  attr_accessor :player1, :board
  @@guesses = 12
  @@correct_code = 0


  def initialize
    
    puts "Welcome to MASTERMIND, you'll have to guess the secret color code of your opponent in 12 opportunities 
    by making a series of pattern guesses selecting from 6 colors: \n red, yellow, green, blue, orange, purple"
    puts "Please write your name"
    player_name = gets.chomp    
    @player = Player.new(player_name)
    puts "If you want to be the creator of the secret code select number 1, if you want to be the guesser select number 2"
    player_choice = gets.chomp.to_i
    @board = Board.new(player_choice)
  end

  def start
    #display_code
    while !game_over?
      turn
    end    
  end

  def turn
      puts "Please #{@player.name} make your guess by placing 4 colors in the order you want"
      guessed_array = gets.chomp.downcase.split
      
      guess(guessed_array)     
  end

  def guess(guessed_array)
    right_guess = 0
    right_color = 0
    puts "You select this combination #{guessed_array}"

     @board.color_code.each_with_index do | color, i |
      puts "trying with color #{color}, in position #{i}"
      guessed_array.each_with_index do |guess, j|
        puts "trying with guess #{guess} in position #{j}"
        if guess == color
          if j == i 
            puts "color_code[#{i}] = #{@board.color_code[i]} and guessed_array[#{j}] = #{guessed_array[j]}"
            right_guess +=1 
          elsif @board.color_code[j] != guess && guessed_array[i] != color
            puts "*color_code[#{j}] = #{@board.color_code[j]} and guessed_array[#{j}] = #{guessed_array[j]}"
            right_color +=1
          end
        end
      end
     end
     @@correct_code = right_guess
     feedback(right_guess, right_color)
    @@guesses -= 1
  end

  def feedback(right_guess, right_color)
    puts right_guess.to_s + " | " + right_color.to_s
  end

  def display_code
    puts board.color_code[0].to_s + " | " + board.color_code[1].to_s + " | " + board.color_code[2].to_s + " | " + board.color_code[3].to_s
  end

  def game_over?

    if victory?
      puts "#{@player.name} WINS!!"
      return true      
    elsif no_guesses_left?
      puts "GAME OVER, NO GUESSES LEFT :( "
      display_code
      return true
    else
      return false
    end
  end

  def victory?
    puts "this is the counter for correct_code #{@@correct_code}"
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
   
   @@colors = ["red", "yellow", "green", "blue", "orange", "purple", "red", "yellow", "green", "blue", "orange", "purple", "red", "yellow", "green", "blue", "orange", "purple", "red", "yellow", "green", "blue", "orange", "purple"]

    def initialize(player_choice)
      if player_choice == 1 
        creator
      elsif player_choice == 2
        guesser
      end       
    end

    def creator
      puts "Please create your code by placing 4 colors (from red, yellow, green, blue, orange, purple) in the order you want"
      @color_code = gets.chomp.downcase.split
    end

    def guesser
       @color_code = @@colors.sample(4)
    end
  end
end

my_game = Mastermind.new
my_game.start
