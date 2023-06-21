class StatementPrinter
  def initialize(io = Kernel)
    @io = io
    @header_row = 'date || credit || debit || balance'
  end

  def print_statement(account)
    statement = generate_statement(account)
    @io.puts(statement)
  end

  def generate_statement(account)
    transfers = format_transfers(account.transfers, account.starting_balance)
    transfers.reverse.unshift(@header_row).join("\n")
  end

  private

  def format_transfers(transfers, balance)
    transfers.map do |transfer|
      balance += transfer.amount
      format_transfer(transfer, balance)
    end
  end
  
  def format_transfer(transfer, balance)
    date = format_date(transfer.timestamp)
    credit = transfer.deposit? ? format_money(transfer.amount) : nil
    debit = transfer.withdrawal? ? format_money(transfer.amount.abs) : nil
    total_balance = format_money(balance)
    join_transfer_array([date, credit, debit, total_balance])
  end

  def join_transfer_array(row)
    amounts = row[1..-2].map { |amount| amount.nil? ? ' ' : " #{amount} " }
    ["#{row[0]} ", *amounts, " #{row[-1]}"].join('||')
  end

  def format_date(date)
    date.strftime('%d/%m/%Y')
  end

  def format_money(amount)
    format('%.2f', amount.to_f)
  end
end
