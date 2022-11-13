# initialize a new game

class Instructions
  def self.introduction
    puts 'Welcome To Tic-Tac-Toe!'
    puts 'In case you need a refresher on how to play:'
    puts 'The goal of the game is to get 3 of your letter (X or O) in a row before the other player.'
    puts 'The row can be across, down or diagonal!'
    puts 'The turn order will be randomly selected. On your turn you will be prompted to enter a move:'
  end

  def self.input_instructions
    puts 'The three rows are labeled top, middle, and bottom'
    puts 'The columns are labed left, middle, an right'
    puts 'To place your letter, type in the row, then the column, seperated by a comma.'
    puts 'For example, if you wanted to place a letter in the middle of the board, tou would enter "middle-middle'
  end

  def self.start
    introduction
    input_instructions
    puts 'Are you ready to begin? (Y/N)'
    confirmation = gets.chomp.downcase
    until confirmation == 'y'
      puts 'No problem, type "y" when you are ready. or to exit the game type "quit"'
      confirmation = gets.chomp.downcase
      return if cofirmation == 'quit' 
    end
  end
end
# create user player
class Player
  attr_reader :name

  def initialize
    puts 'Please enter your name'
    @name = gets.chomp
  end

  def take_turn
    puts 'Please enter your move:'
    check_input(gets.chomp.downcase.split('-'))
  end

  def check_input(move)
    until (move[0] == 'top' || move[0] == 'middle' || move[0] == 'bottom') &&
          (move[1] == 'left' || move[1] == 'middle' || move[1] == 'right') 
      puts 'Please try again. As a reminder here are the input instructions:'
      Instructions.input_instructions
      move = gets.chomp.downcase.split('-')
    end
    move
  end
end
# AI player - Single Purpose decide computers moves
class Computer
  attr_reader :name

  def initialize
    @name = "The Computer"
  end

  def take_turn
    [decide_row, decide_column]
  end

  private

  def decide_row
    @row =
      case rand(1..3)
      when 1
        'top'
      when 2
        'middle'
      when 3
        'bottom'
      end
  end

  def decide_column
    @column =
      case rand(1..3)
      when 1
        'left'
      when 2
        'middle'
      when 3
        'right'
      end
  end
end

class GameBoard
  attr_accessor :board, :winner

  def initialize
    @board = [[' ', ' ', ' '], [' ', ' ', ' '], [' ', ' ', ' ']]
    @winner = 0
  end

  def display_board
    board.each do |row|
      puts "#{row[0]} | #{row[1]} | #{row[2]}"
    end
  end

  def check_for_winner
    row_win
    column_win
    diagonal_win
    @winner
  end

  private

  def row_win
    board.each do |row|
      if row.all?('X')
        @winner = 1
      elsif row.all?('O')
        @winner = 2
      end
    end
  end

  def diagonal_win
    win_conditions = [[board[0][0], board[1][1], board[2][2]], [board[0][2], board[1][1], board[2][0]]]
    @winner = 1 if win_conditions.any?(['X','X','X'])
    @winner = 2 if win_conditions.any?(['O','O','O'])
  end

  def column_win
    if [board[0][0], board[1][0], board[2][0]].all?("X") ||
       [board[0][1], board[1][1], board[2][1]].all?("X") ||
       [board[0][2], board[1][2], board[2][2]].all?("X")
      @winner = 1
    elsif [board[0][0], board[1][0], board[2][0]].all?("O") ||
          [board[0][1], board[1][1], board[2][1]].all?("O") ||
          [board[0][2], board[1][2], board[2][2]].all?("O")
      @winner = 2
    end
  end
end

class Game
  def initialize
    Instructions.start
    choose_first_player
    @game_board = GameBoard.new
    play_game
  end

  private

  def choose_first_player
    if rand(1..2) == 1
        @player1 = Player.new
        @player2 = Computer.new
      else
        @player1 = Computer.new
        @player2 = Player.new
      end
      puts "#{@player1.name} is player 1!"
  end

  def request_turn(player, letter)
    loop do
      move = player.take_turn
      spot_on_board = convert_turn_to_board_space(move)
      if @game_board.board[spot_on_board[0]][spot_on_board[1]] == ' '
        @game_board.board[spot_on_board[0]][spot_on_board[1]] = letter
        break
      end
      puts 'Space is not available. Please choose another move:' if player.instance_of?(Player)
    end
  end

  def convert_turn_to_board_space(turn)
    case turn[0]
    when 'top'
      turn[0] = 0
    when 'middle'
      turn[0] = 1
    when 'bottom'
      turn[0] = 2
    end
    case turn[1]
    when 'left'
      turn[1] = 0
    when 'middle'
      turn[1] = 1
    when 'right'
      turn[1] = 2
    end
    turn
  end

  def play_game
    while @game_board.check_for_winner.zero?
      @game_board.display_board
      request_turn(@player1, 'X')      
      break unless @game_board.check_for_winner.zero?

      puts "Player 2's turn"
      request_turn(@player2, 'O')

    end
    display_winner
  end

  def display_winner
    if @game_board.check_for_winner == 1
      puts 'Player 1 Wins!'
    else
      puts 'Player 2 Wins!'
    end
  end
end

Game.new
