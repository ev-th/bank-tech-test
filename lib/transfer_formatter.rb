class TransferFormatter
  attr_reader :field_names

  def initialize
    @field_names = ['date', 'credit', 'debit', 'balance']
  end

  def format_transfer(transfer, balance)
    date = format_date(transfer.timestamp)
    credit = transfer.deposit? ? format_money(transfer.amount) : nil
    debit = transfer.withdrawal? ? format_money(transfer.amount.abs) : nil
    total_balance = format_money(balance)
    [date, credit, debit, total_balance]
  end
  
  def format_one(transfer, balance)
    date = format_date(transfer.timestamp)
    credit = transfer.deposit? ? format_money(transfer.amount) : nil
    debit = transfer.withdrawal? ? format_money(transfer.amount.abs) : nil
    total_balance = format_money(balance)
    [date, credit, debit, total_balance]
  end

  def format_many(transfers, initial_balance)
    running_total_balance = initial_balance
    sorted_transfers = sort_transfers(transfers)
    sorted_transfers.map do |transfer|
      running_total_balance += transfer.amount
      format_one(transfer, running_total_balance)
    end
  end

  private

  def sort_transfers(transfers)
    transfers.sort_by { |transfer| transfer.timestamp }
  end

  def format_date(date)
    date.strftime('%d/%m/%Y')
  end

  def format_money(amount)
    format('%.2f', amount.to_f)
  end
end
