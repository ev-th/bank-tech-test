class BankAccount
  attr_reader :starting_balance, :transfers

  def initialize
    @starting_balance = 0
    @transfers = []
  end

  def add_transfer(transfer)
    @transfers.push transfer
  end
end
