class StatementPrinter
  def initialize(io = Kernel)
    @io = io
  end

  def print_statement(account)
    statement = generate_statement(account)
    @io.puts(statement)
  end

  def generate_statement(account)
    rows = ['date || credit || debit || balance']
    balance = account.starting_balance

    formatted_transfers = account.transfers.map do |transfer|
      balance += transfer[:credit] - transfer[:debit]
      transfer_to_s(transfer, balance)
    end

    (rows + formatted_transfers.reverse).join("\n")
  end

  private

  def transfer_to_s(transfer, balance)
    transfer_s = "#{format_date(transfer[:date])} || "

    if transfer[:debit].zero?
      transfer_s += "#{format_money(transfer[:credit])} ||"
    elsif transfer[:credit].zero?
      transfer_s += "|| #{format_money(transfer[:debit])}"
    end

    transfer_s + " || #{format_money(balance)}"
  end

  def format_money(amount)
    format('%.2f', amount.to_f)
  end

  def format_date(date)
    date.strftime('%d/%m/%Y')
  end
end