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

a = Player.new
p a
p a.take_turn