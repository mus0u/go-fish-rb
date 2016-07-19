require 'forwardable'
require 'card'
class Deck
  extend Forwardable

  def_delegators :@cards, :empty?, :length, :shuffle!, :size

  def initialize
    @cards = Card::SUITS.product(Card::RANKS).map do |suit, rank|
      Card.new rank, suit
    end
  end

  def deal! quantity=false
    if quantity
      quantity.times.map{ @cards.pop }.compact
    else
      @cards.pop
    end
  end
end
