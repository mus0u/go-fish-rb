require 'minitest/autorun'
require 'card'

class TestCard < MiniTest::Test
  def test_a_card_has_a_rank
    jack_of_clubs = Card.new :J, :Clubs
    assert_equal :J, jack_of_clubs.rank
  end

  def test_a_card_has_a_suit
    four_of_hearts = Card.new 4, :Hearts
    assert_equal :Hearts, four_of_hearts.suit
  end

  def test_fails_on_invalid_numeric_rank
    assert_raises ArgumentError do
      Card.new 12, :Hearts
    end
  end

  def test_fails_on_invalid_court_rank
    assert_raises ArgumentError do
      Card.new :B, :Spades
    end
  end

  def test_fails_on_invalid_suit
    assert_raises ArgumentError do
      Card.new 9, :Weasels
    end
  end

  def test_cards_of_equal_rank_are_equal
    seven_of_hearts = Card.new 7, :Hearts
    seven_of_clubs = Card.new 7, :Clubs
    assert_equal seven_of_hearts, seven_of_clubs
  end

  def test_a_cards_rank_may_not_be_altered
    nine_of_diamonds = Card.new 9, :Diamonds
    assert_raises NoMethodError do
      nine_of_diamonds.rank = 8
    end
  end

  def test_a_cards_suit_may_not_be_altered
    nine_of_diamonds = Card.new 9, :Diamonds
    assert_raises NoMethodError do
      nine_of_diamonds.suit = :Hearts
    end
  end
end
