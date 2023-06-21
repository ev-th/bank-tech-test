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
    (headers + transfers).join("\n")
  end

  private

  def format_transfers(transfers, balance)
    formatted_transfers = transfers.map do |transfer|
      balance += transfer.amount
      format_transfer(transfer, balance)
    end
    formatted_transfers.reverse
  end

  def format_transfer(transfer, balance)
    row = [
      format_date(transfer.timestamp),
      transfer.deposit? ? format_money(transfer.amount) : '',
      transfer.withdrawal? ? format_money(transfer.amount.abs) : '',
      format_money(balance)
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
        ' '
      else
        " #{element} "
      end
    end
    formatted_elements.join('||')
  end

  def format_date(date)
    date.strftime('%d/%m/%Y')
  end

  def format_money(amount)
    format('%.2f', amount.to_f)
  end
end
