class Transfer
  attr_reader :amount
  def initialize(amount)
    fail 'The transfer amount cannot be 0' if amount.zero?
    
    @type = amount.positive? ? 'deposit' : 'withdrawal'
    @amount = amount.abs
  end

  def deposit?
    @type == 'deposit'
  end

  def withdrawal?
    @type == 'withdrawal'
  end
end
