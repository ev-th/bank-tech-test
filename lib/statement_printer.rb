# frozen_string_literal: true

require_relative './transfer_formatter'

class StatementPrinter
  def initialize(io = Kernel, transfer_formatter = TransferFormatter.new)
    @io = io
    @formatter = transfer_formatter
  end

  def print_statement(account)
    statement = generate_statement(account)
    @io.puts(statement)
  end

  def generate_statement(account)
    headers = @formatter.field_names.join(' || ')
    transfers = format_transfers(account.transfers, account.starting_balance)
    ([headers] + transfers).join("\n")
  end

  private

  def format_transfers(transfers, starting_balance)
    transfers_array = @formatter.format_many(transfers, starting_balance)
    transfers_array.map {|transfer| join_transfer_array(transfer)}.reverse
  end

  def join_transfer_array(row)
    central_columns = row[1..-2].map { |amount| amount.nil? ? ' ' : " #{amount} " }
    ["#{row[0]} ", *central_columns, " #{row[-1]}"].join('||')
  end
end
