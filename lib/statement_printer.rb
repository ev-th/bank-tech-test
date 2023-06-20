class StatementPrinter
  def initialize(io = Kernel)
    @io = io
  end

  def print_statement(account)
    statement = generate_statement(account)
    @io.puts(statement)
  end

  def generate_statement(account)
    headers = ['date || credit || debit || balance']
    transfers = format_transfers(account.transfers, account.starting_balance)
    (headers + transfers.reverse).join("\n")
  end

  private

  def format_transfers(transfers, starting_balance)
    running_total = starting_balance
    return transfers.map do |transfer|
      
      running_total += transfer.amount if transfer.deposit?
      running_total -= transfer.amount if transfer.withdrawal?
      format_transfer(transfer, running_total)
    end
  end

  def format_transfer(transfer, updated_balance)
    columns = ["#{format_date(transfer.timestamp)} || "]

    if transfer.deposit?
      columns.push "#{format_money(transfer.amount)} ||"
    elsif transfer.withdrawal?
      columns.push "|| #{format_money(transfer.amount)}"
    end

    columns.push " || #{format_money(updated_balance)}"
    columns.join
  end

  def format_money(amount)
    format('%.2f', amount.to_f)
  end

  def format_date(date)
    date.strftime('%d/%m/%Y')
  end
end