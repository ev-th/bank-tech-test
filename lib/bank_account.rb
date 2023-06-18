class BankAccount
  def initialize
    @balance = 0
    @transfers = []
  end

  def statement
    rows = ['date || credit || debit || balance']
    rows += @transfers.reverse.map { |transfer| transfer_to_s(transfer) }

    rows.join("\n")
  end

  def deposit(amount, current_date = Time.now)
    make_transfer(current_date, credit: amount)
  end

  def withdraw(amount, current_date = Time.now)
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
    transfer_s = "#{format_date(transfer[:date])} || "

    if transfer[:debit].zero?
      transfer_s += "#{format_money(transfer[:credit])} ||"
    elsif transfer[:credit].zero?
      transfer_s += "|| #{format_money(transfer[:debit])}"
    end

    transfer_s + " || #{format_money(transfer[:balance])}"
  end

  def format_money(amount)
    format('%.2f', amount.to_f)
  end

  def format_date(date)
    date.strftime('%d/%m/%Y')
  end
end
