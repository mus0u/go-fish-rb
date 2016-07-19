class Player
  attr_reader :name, :books

  def initialize name, deck
    @name, @deck = name, deck
    @hand = []
    @books = {}
  end

  def to_s
    @name
  end

  def print_hand
    puts "#{self}, your hand is:"
    @hand.sort.each do |card|
      puts "\t#{card}"
    end
  end

  def print_books
    puts "#{self} has #{@books.size} completed books: (#{@books.keys.join(', ')})." if @books.any?
  end

  def draw_starting_hand
    @hand = @deck.deal! 9
  end

  def go_fish
    if new_card = @deck.deal!
      puts "#{self}, you drew the #{new_card}."
      @hand.push new_card
    else
      puts 'The deck is empty.'
    end
  end

  def take rank
    matches, @hand = @hand.partition do |card|
      card.rank == rank
    end
    if @hand.empty? && !@deck.empty?
      puts "Emptied #{self}'s hand. Taking a card from the deck."
      @hand.push @deck.deal!
    end
    matches
  end

  def ask_for opponent, rank
    puts "#{opponent}, got any #{rank}'s?"
    result = opponent.take rank
    if result.any?
      @hand += result
      puts "#{opponent} had #{result.size}."
    else
      puts "Nope! Go fish."
      go_fish
    end
  end

  def score_books!
    # build a count of cards in hand, grouped by rank
    rank_counts = @hand.each_with_object Hash.new do |card, rank_counts|
      rank_counts[card.rank] = if rank_counts[card.rank].nil?
                                 1
                               else
                                 rank_counts[card.rank] + 1
                               end
    end
    # if we have all the cards of a rank, remove them from hand and
    # add them to our books
    completed_ranks = rank_counts.select do |_, count|
      count == Card::SUITS.size
    end.each do |completed_rank, _|
      puts "#{self}, you completed the book of #{completed_rank}'s!"
      @books[completed_rank] = take completed_rank
    end
  end
end
