# /home/notcominghome/repos/tic_tac_toe
# frozen_string_literal: true

# print instructions and ask to begin game - module because no need for instance
module Instructions
  def self.introduction
    puts 'Welcome To Tic-Tac-Toe!'
    puts 'In case you need a refresher on how to play:'
    puts 'The goal of the game is to get 3 of your letter (X or O) in a row before the other player.'
    puts 'The row can be across, down or diagonal!'
    puts 'The turn order will be randomly selected. On your turn you will be prompted to enter a move:'
  end

  def self.input_instructions
    puts 'The three rows are labeled top, middle, and bottom'
    puts 'The columns are labed left, middle, and right'
    puts "To place your letter, type in the row, then the column, seperated by a '-'."
    puts 'For example, if you wanted to place a letter in the middle of the board, you would enter "middle-middle'
  end

  def self.start
    introduction
    input_instructions
    puts 'Are you ready to begin? (Y/N)'
    confirmation = gets.chomp.downcase
    until confirmation == 'y'
      puts 'No problem, type "y" when you are ready. or to exit the game type "quit"'
      confirmation = gets.chomp.downcase
      return 'quit' if confirmation == 'quit'
    end
  end
end

# represents user
class Player
  attr_reader :name

  def initialize(name)
    @name = name
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

# represents AI, not subclass of player because all methods would need override anyway
class Computer
  attr_reader :name

  def initialize
    @name = 'The Computer'
  end

  def take_turn
    [decide_row, decide_column]
  end

  private

  def decide_row
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

# instance of board, checks win conditions via index of 2d array on board and displays board
class GameBoard
  attr_accessor :board, :winner, :win_conditions

  def initialize
    @board = [[' ', ' ', ' '], [' ', ' ', ' '], [' ', ' ', ' ']]
    @winner = 0
    @win_conditions = { diagonal_win: [], column_win: [], row_win: [] }
  end

  def display_board
    puts ''
    board.each_with_index do |row, index|
      puts "#{row[0]} | #{row[1]} | #{row[2]}"
      puts '---------' if index < 2
    end
    puts ''
  end

  def check_for_winner
    check_win_conditions
    @winner = 3 unless board.flatten.any?(' ')
    @winner = 1 if win_conditions.values.flatten(1).any?(%w[X X X])
    @winner = 2 if win_conditions.values.flatten(1).any?(%w[O O O])
    @winner
  end

  private

  # unable to fix assignment complexity w/o converting to multiple assignment methods
  # which seems more convoluted, not less
  def check_win_conditions
    win_conditions[:diagonal_win] = [[board[0][0], board[1][1], board[2][2]], [board[0][2], board[1][1], board[2][0]]]
    win_conditions[:column_win] = board.transpose
    win_conditions[:row_win] = board.map { |row| row }
  end
end

# needed to control game flow
class Game
  def initialize
    return if Instructions.start == 'quit'

    create_players
    @game_board = GameBoard.new
    play_game
  end

  def create_players
    puts 'Who is player 1?'
    user1 = Player.new(gets.chomp)
    puts "Who is player 2? If playing single-player, please enter 'computer'."
    user2_name = gets.chomp.downcase
    user2 = if user2_name == 'computer'
              Computer.new
            else
              Player.new(user2_name)
            end
    choose_first_player([user1, user2])
  end

  private

  def choose_first_player(users)
    if rand(1..2) == 1
      @player1 = users[0]
      @player2 = users[1]
    else
      @player1 = users[1]
      @player2 = users[0]
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

  # dont see how I could make this simpler
  def convert_turn_to_board_space(turn)
    turn.each_with_index do |_, index|
      turn[index] = case turn[index]
                    when 'top', 'left'
                      0
                    when 'middle'
                      1
                    else
                      turn[index] = 2
                    end
    end
  end

  def play_game
    while @game_board.check_for_winner.zero?
      @game_board.display_board
      puts "#{@player1.name.upcase}'s TURN"
      request_turn(@player1, 'X')
      @game_board.display_board
      break unless @game_board.check_for_winner.zero?

      puts "#{@player2.name.upcase}'s TURN"
      request_turn(@player2, 'O')
    end
    display_winner
  end

  def display_winner
    case @game_board.check_for_winner
    when 1
      puts "#{@player1.name.capitalize} Wins!"
    when 3
      puts 'Its a tie game!'
    else
      puts "#{@player2.name.capitalize} Wins!"
    end
  end
end

Game.new
