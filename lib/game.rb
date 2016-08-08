lib_dir = File.dirname __FILE__
$LOAD_PATH.unshift lib_dir unless $LOAD_PATH.include? lib_dir
require 'set'
require 'deck'
require 'player'
class Game
  DIVIDER = ("=" * 80).freeze
  ALL_BOOKS = Set.new Card::RANKS

  def initialize
    @deck = Deck.new
    @completed_books = Set.new
    puts DIVIDER
    puts "Go Fish!".center 80
    puts DIVIDER
    print "Player 1, please enter your name: "
    @active_player = Player.new gets.chomp, @deck
    print "Player 2, please enter your name: "
    @opponent = Player.new gets.chomp, @deck
    puts DIVIDER
  end

  def run
    puts "Okay, let's start the game!"
    @deck.shuffle!
    [@active_player, @opponent].each &:draw_starting_hand
    while game_not_finished?
      handle_turn
      swap_players!
    end
    # set the winner to be the active player for the score screen
    swap_players! if @active_player.books.size < @opponent.books.size
    display_final_score
    exit 0
  end

  private

  def handle_turn
    puts DIVIDER
    puts "#@active_player's turn!".center 80
    [@active_player, @opponent].each &:print_books
    @active_player.print_hand
    guess = handle_guess
    @active_player.ask_for @opponent, guess
    @active_player.score_books!
    @completed_books.merge @active_player.books.keys
  end

  def handle_guess
    puts "#@active_player, what will you ask #@opponent for? " \
         "(2 through 10, J, Q, K, or A?)"
    input = gets.chomp
    case input
    when 'J', 'Q', 'K', 'A'
      input.to_sym
    when *(2..10).map(&:to_s)
      input.to_i
    else
      puts "Sorry, I didn't understand your guess: #{input.inspect}"
      handle_guess
    end
  end

  def display_final_score
    puts DIVIDER
    puts "#@active_player wins!".center 80
    print "#@active_player".center 40
    puts "#@opponent".center 40
    print "Completed books:".center 40
    puts "Completed books:".center 40
    # generate 40-wide column of winner's books,
    # zip with 40-wide column of opponent's books,
    # concatenate, and print
    @active_player.books.keys.map do |book|
      book.to_s.center 40
    end.zip(@opponent.books.keys.map do |book|
      book.to_s.center 40
    end).each do |winner_column, opponent_column|
      puts winner_column + (opponent_column || '')
    end
  end

  def swap_players!
    @active_player, @opponent = @opponent, @active_player
  end

  def game_not_finished?
    @completed_books != ALL_BOOKS
  end
end
