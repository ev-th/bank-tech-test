class Transfer
  attr_reader :amount, :timestamp
  
  def initialize(amount, timestamp = Time.now)
    raise 'The transfer amount cannot be 0' if amount.zero?

    @amount = amount
    @timestamp = timestamp
  end

  def deposit?
    @amount.positive?
  end

  def withdrawal?
    @amount.negative?
  end
end
