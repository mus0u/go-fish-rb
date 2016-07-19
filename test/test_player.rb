require 'minitest/autorun'
require 'player'
class TestPlayer < MiniTest::Test
  def setup
    @player = Player.new 'Karl', Deck.new
  end

  def test_a_player_has_a_name
    assert_equal 'Karl', @player.name
  end

  def test_a_player_can_draw_from_the_deck
    assert_output "Karl, you drew the A of Spades.\n" do
      @player.go_fish
    end
    assert_equal 1, @player.instance_variable_get(:@hand).size
  end

  def test_a_player_can_draw_a_starting_hand
    @player.draw_starting_hand
    assert_equal 9, @player.instance_variable_get(:@hand).size
  end

  def test_a_player_can_be_taken_from
    # assumes unshuffled deck
    @player.draw_starting_hand
    aces = @player.take :A
    assert_equal 1, aces.size
    assert_equal :A, aces[0].rank
    assert_equal :Spades, aces[0].suit
    assert_equal 8, @player.instance_variable_get(:@hand).size
  end

  def test_a_player_can_score_a_book
    book_of_aces = [ Card.new(:A, :Spades),
                     Card.new(:A, :Hearts),
                     Card.new(:A, :Diamonds),
                     Card.new(:A, :Clubs),
                   ]
    @player.instance_variable_set :@hand, book_of_aces
    assert_output "Karl, you completed the book of A's!\n" \
                  "Emptied Karl's hand. Taking a card from the deck.\n" do
      @player.score_books!
    end
    assert_equal({:A => book_of_aces}, @player.books)
  end

  def test_a_player_can_score_two_books_with_hand_left_over
    book_of_aces = [ Card.new(:A, :Spades),
                     Card.new(:A, :Hearts),
                     Card.new(:A, :Diamonds),
                     Card.new(:A, :Clubs),
                   ]
    book_of_eights = [ Card.new(8, :Spades),
                       Card.new(8, :Hearts),
                       Card.new(8, :Diamonds),
                       Card.new(8, :Clubs),
                     ]
    leftovers = [Card.new(2, :Clubs), Card.new(4,:Diamonds)]
    hand = (book_of_aces + book_of_eights + leftovers).shuffle!
    @player.instance_variable_set :@hand, hand
    assert_output nil do # silence stdout on this call since it's hard
                         # to test in this example, and that
                         # functionality is tested elsewhere
      @player.score_books!
    end
    assert_equal({ :A => book_of_aces, 8 => book_of_eights}, @player.books)
    assert_equal leftovers.sort, @player.instance_variable_get(:@hand).sort
  end
end
