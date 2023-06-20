class Transfer
  attr_reader :amount
  def initialize(amount)
    @amount = amount.abs
  end
end