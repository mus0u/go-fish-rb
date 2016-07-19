require 'minitest/autorun'
require 'deck'

class TestDeck < MiniTest::Test
  def setup
    @deck = Deck.new
  end

  def test_a_deck_has_52_cards
    assert_equal 52, @deck.length
  end

  def test_dealing_from_an_unshuffled_deck
    card = @deck.deal!
    assert_equal Card, card.class
    assert_equal :A, card.rank
    assert_equal :Spades, card.suit
  end

  def test_dealing_multiple_from_an_unshuffled_deck
    cards = @deck.deal! 3
    cards.each do |card|
      assert_equal Card, card.class
      assert_equal :Spades, card.suit
    end
    assert_equal :A, cards[0].rank
    assert_equal :K, cards[1].rank
    assert_equal :Q, cards[2].rank
  end

  def test_dealing_from_an_empty_deck_returns_nil
    @deck.deal! 52
    assert_equal nil, @deck.deal!
  end

  def test_dealing_multiple_from_an_empty_deck_returns_empty_array
    @deck.deal! 52
    assert_equal [], @deck.deal!(10)
  end

  def test_dealing_multiple_from_a_short_deck_returns_only_the_remaining_cards
    @deck.deal! 50
    cards = @deck.deal! 10
    assert_equal 2, cards.size
    cards.each do |card|
      assert_equal Card, card.class
    end
  end
end
