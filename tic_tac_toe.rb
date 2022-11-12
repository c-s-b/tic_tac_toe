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