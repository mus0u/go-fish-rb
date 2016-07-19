class Card
  include Comparable
  attr_reader :rank, :suit

  RANKS = ((2..10).to_a + [:J, :Q, :K, :A]).freeze
  SUITS = [:Clubs, :Diamonds, :Hearts, :Spades].freeze

  def initialize rank, suit
    fail ArgumentError.new 'invalid suit' unless self.class.valid_suit? suit
    fail ArgumentError.new 'invalid rank' unless self.class.valid_rank? rank
    @rank, @suit = rank, suit
  end

  def <=> other_card
    RANKS.index(rank) <=> RANKS.index(other_card.rank)
  end

  def to_s
    "#{rank} of #{suit}"
  end

  def self.valid_rank? rank
    RANKS.include? rank
  end

  def self.valid_suit? suit
    SUITS.include? suit
  end
end
