# frozen_string_literal: true

require_relative './transfer_formatter'

class StatementPrinter
  def initialize(io = Kernel, transfer_formatter = TransferFormatter.new)
    @io = io
    @transfer_formatter = transfer_formatter
  end

  def print_statement(account)
    statement = generate_statement(account)
    @io.puts(statement)
  end

  def generate_statement(account)
    transfers = format_transfers(account.transfers, account.starting_balance)
    transfers.reverse.unshift(@transfer_formatter.fields.join(' || ')).join("\n")
  end

  private

  def format_transfers(transfers, balance)
    transfers.map do |transfer|
      balance += transfer.amount
      transfer_array = @transfer_formatter.format_transfer(transfer, balance)
      join_transfer_array(transfer_array)
    end
  end

  def join_transfer_array(row)
    central_columns = row[1..-2].map { |amount| amount.nil? ? ' ' : " #{amount} " }
    ["#{row[0]} ", *central_columns, " #{row[-1]}"].join('||')
  end
end
