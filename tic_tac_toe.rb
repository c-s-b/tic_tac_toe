# initialize a new game

# create user player
class Player
  def initialize
    puts 'Please enter your name'
    @name = gets.chomp
  end

  def take_turn
    puts 'Please enter your move'
    gets.chomp.downcase.split('-')
  end
end

# AI player - Single Purpose decide computers moves
class Computer
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
        'end'
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
    @board = [Array.new(3), Array.new(3), Array.new(3)]
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
    @winner = 1 if win_conditions[0].all?('X') || win_conditions[1].all?('X')
    @winner = 2 if win_conditions[0].all?('O') || win_conditions[1].all?('O')
  end

  def column_win
    if board[0][0] = 'X' && board[1][0] = 'X' && board[2][0] = 'X' ||
       board[0][1] = 'X' && board[1][1] = 'X' && board[2][1] = 'X' ||
       board[0][2] = 'X' && board[1][2] = 'X' && board[2][2] = 'X'
      winner = 1
    elsif board[0][0] = 'O' && board[1][0] = 'O' && board[2][0] = 'O' ||
          board[0][1] = 'O' && board[1][1] = 'O' && board[2][1] = 'O' ||
          board[0][2] = 'O' && board[1][2] = 'O' && board[2][2] = 'O'
      winner = 2
    end
  end

end
a = GameBoard.new
a.display_board
puts a.check_for_winner