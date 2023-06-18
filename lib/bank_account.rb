class BankAccount
  def initialize
    @balance = 0
    @transfers = []
  end

  def statement
    header = "date || credit || debit || balance" 
    return header + "\n" + deposit_to_s(@transfers[0]) if @transfers.length == 1
    return header
  end

  def deposit(amount, current_time)
    @balance += amount

    transfer = {
      date: current_time,
      credit: amount,
      debit: 0,
      balance: @balance
    }

    @transfers.push(transfer)
  end

  private

  def deposit_to_s(transfer)
    # binding.irb
    return transfer[:date].strftime("%d/%m/%Y") +
    " || " + transfer_amount_to_s(transfer[:credit]) +
    " || " + 
    "|| " + transfer_amount_to_s(transfer[:balance])
  end

  def transfer_amount_to_s(amount)
    sprintf("%.2f", amount.to_f)
  end
end