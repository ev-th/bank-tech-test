class TransferFormatter
  attr_reader :field_names

  def initialize
    @field_names = ['date', 'credit', 'debit', 'balance']
  end

  def format_one(transfer, balance)
    [
      format_date(transfer.timestamp),
      transfer.deposit? ? format_money(transfer.amount) : nil,
      transfer.withdrawal? ? format_money(transfer.amount.abs) : nil,
      format_money(balance)
    ]
  end

  def format_many(transfers, balance)
    sorted_transfers = transfers.sort_by { |transfer| transfer.timestamp }
    sorted_transfers.map do |transfer|
      balance += transfer.amount
      format_one(transfer, balance)
    end
  end

  private

  def format_date(timestamp)
    timestamp.strftime('%d/%m/%Y')
  end

  def format_money(amount)
    format('%.2f', amount.to_f)
  end
end
