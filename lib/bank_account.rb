require_relative './transfer'

class BankAccount
  attr_reader :starting_balance, :transfers

  def initialize(transfer: Transfer, time: Time)
    @transfer = transfer
    @time = time
    
    @starting_balance = 0
    @transfers = []
  end
  
  def deposit(amount)
    add_transfer(amount)
  end
  
  def withdraw(amount)
    add_transfer(-amount)
  end
  
  private

  def add_transfer(amount)
    @transfers.push @transfer.new(amount, @time.now)
  end
end
