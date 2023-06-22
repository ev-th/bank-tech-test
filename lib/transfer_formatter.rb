class TransferFormatter
  attr_reader :fields

  def initialize
    @fields = ['date', 'credit', 'debit', 'balance']
  end

  def format_transfer(transfer, balance)
    date = format_date(transfer.timestamp)
    credit = transfer.deposit? ? format_money(transfer.amount) : nil
    debit = transfer.withdrawal? ? format_money(transfer.amount.abs) : nil
    total_balance = format_money(balance)
    [date, credit, debit, total_balance]
  end

  private

  def format_date(date)
    date.strftime('%d/%m/%Y')
  end

  def format_money(amount)
    format('%.2f', amount.to_f)
  end
end
