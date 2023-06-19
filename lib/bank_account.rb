class BankAccount
  attr_reader :starting_balance, :transfers

  def initialize
    @starting_balance = 0
    @transfers = []
  end

  def deposit(amount, current_date = Time.now)
    make_transfer(current_date, credit: amount)
  end

  def withdraw(amount, current_date = Time.now)
    make_transfer(current_date, debit: amount)
  end

  private

  def make_transfer(current_date, credit: 0, debit: 0)
    @transfers.push(
      { date: current_date, credit: credit, debit: debit }
    )
  end
end
