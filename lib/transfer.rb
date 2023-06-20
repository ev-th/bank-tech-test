class Transfer
  attr_reader :amount, :timestamp
  
  def initialize(amount, timestamp = Time.now)
    raise 'The transfer amount cannot be 0' if amount.zero?

    @type = amount.positive? ? 'deposit' : 'withdrawal'
    @amount = amount.abs
    @timestamp = timestamp
  end

  def deposit?
    @type == 'deposit'
  end

  def withdrawal?
    @type == 'withdrawal'
  end
end
