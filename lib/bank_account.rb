class BankAccount
  def initialize
    @balance = 0
    @transfers = []
  end

  def statement
    rows = ["date || credit || debit || balance"]
    rows += @transfers.reverse.map { |transfer| transfer_to_s(transfer)}

    return rows.join("\n")
  end

  def deposit(amount, current_date)
    make_transfer(current_date, credit: amount)
  end
  
  def withdrawal(amount, current_date)
    make_transfer(current_date, debit: amount)
  end

  private
  
  def make_transfer(current_date, credit: 0, debit: 0)
    @balance += credit - debit
    
    transfer = {
      date: current_date,
      credit: credit,
      debit: debit,
      balance: @balance
    }

    @transfers.push(transfer)
  end
  
  def transfer_to_s(transfer)
    formatted_transfer = [format_date(transfer[:date]) + " || "]
    
    if transfer[:debit].zero?
      formatted_transfer.push(amount_to_s(transfer[:credit]) + " ||")
    else
      formatted_transfer.push("|| " + amount_to_s(transfer[:debit]))
    end

    formatted_transfer.push(" || " + amount_to_s(transfer[:balance]))

    formatted_transfer.join("")

  end

  def amount_to_s(amount)
    sprintf("%.2f", amount.to_f)
  end

  def format_date(date)
    date.strftime("%d/%m/%Y")
  end
end