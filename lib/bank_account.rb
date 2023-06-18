class BankAccount
  def initialize
    @balance = 0
    @transfers = []
  end

  def statement
    header = ["date || credit || debit || balance"]

    transfers = @transfers.reverse.each do |transfer|
      # binding.irb
      header << deposit_to_s(transfer) if transfer[:debit].zero?
      header << withdrawal_to_s(transfer) if transfer[:credit].zero?
    end

    return header.join("\n")
  end

  def deposit(amount, current_date)
    make_transfer(current_date, credit: amount)
  end
  
  def withdrawal(amount, current_date)
    make_transfer(current_date, debit: amount)
  end

  private
  
  def make_transfer(current_date, credit: 0, debit: 0)
    @balance += credit
    @balance -= debit
    
    transfer = {
      date: current_date,
      credit: credit,
      debit: debit,
      balance: @balance
    }

    @transfers.push(transfer)
  end
  
  def deposit_to_s(transfer)
    return transfer[:date].strftime("%d/%m/%Y") +
    " || " + transfer_amount_to_s(transfer[:credit]) +
    " || " + 
    "|| " + transfer_amount_to_s(transfer[:balance])
  end

  def withdrawal_to_s(transfer)
    return transfer[:date].strftime("%d/%m/%Y") +
    " || " + 
    "|| " + transfer_amount_to_s(transfer[:debit]) +
    " || " + transfer_amount_to_s(transfer[:balance])
  end

  def transfer_amount_to_s(amount)
    sprintf("%.2f", amount.to_f)
  end
end