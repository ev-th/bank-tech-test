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
    credit = transfer.deposit? ? transfer.amount : 0
    debit = transfer.withdrawal? ? transfer.amount : 0

    row = [
      format_date(transfer.timestamp),
      credit.zero? ? "" : format_money(credit),
      debit.zero? ? "" : format_money(debit),
      format_money(updated_balance)
    ]

    join_row(row)
  end

  def join_row(row)
    formatted_elements = row.map.with_index do |element, i|
      if i.zero?
        "#{element} "
      elsif i == row.length - 1
        " #{element}"
      elsif element.empty?
        " "
      else
        " #{element} "
      end
    end
    formatted_elements.join("||")
  end

  def format_date(date)
    "#{date.strftime('%d/%m/%Y')}"
  end

  def format_money(amount)
    "#{format('%.2f', amount.to_f)}"
  end
end