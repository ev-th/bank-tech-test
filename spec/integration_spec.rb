require 'bank_account'
require 'statement_printer'
require 'transfer'

RSpec.describe 'integration' do
  context 'when the client sets up an account' do
    it 'prints an empty bank statement' do
      account = BankAccount.new

      fake_io = double :fake_io
      expect(fake_io).to receive(:puts).with(
        'date || credit || debit || balance'
      )
      printer = StatementPrinter.new(fake_io)

      printer.print_statement(account)
    end
  end

  context 'when the client makes a deposit' do
    it 'prints the statement including the deposit with a total' do
      account = BankAccount.new
      date = Time.new(2023, 1, 10)
      deposit = Transfer.new(1000, date)
      account.add_transfer(deposit)

      fake_io = double :fake_io
      expect(fake_io).to receive(:puts).with(
        "date || credit || debit || balance\n" \
          '10/01/2023 || 1000.00 || || 1000.00'
      )
      printer = StatementPrinter.new(fake_io)

      printer.print_statement(account)
    end
  end

  context 'when the client makes a withdrawal' do
    it 'prints the statement including the withdrawal with a total' do
      account = BankAccount.new
      date = Time.new(2023, 1, 14)
      withdrawal = Transfer.new(-500, date)
      account.add_transfer(withdrawal)

      fake_io = double :fake_io
      expect(fake_io).to receive(:puts).with(
        "date || credit || debit || balance\n" \
        '14/01/2023 || || 500.00 || -500.00'
      )
      printer = StatementPrinter.new(fake_io)

      printer.print_statement(account)
    end
  end

  context 'when a client makes multiple transfers' do
    it 'prints the statement including all transfers and running totals' do
      account = BankAccount.new

      date1 = Time.new(2023, 1, 10)
      transfer1 = Transfer.new(1000, date1)
      account.add_transfer(transfer1)

      date2 = Time.new(2023, 1, 13)
      transfer2 = Transfer.new(2000, date2)
      account.add_transfer(transfer2)

      date3 = Time.new(2023, 1, 14)
      transfer3 = Transfer.new(-500, date3)
      account.add_transfer(transfer3)

      fake_io = double :fake_io
      expect(fake_io).to receive(:puts).with(
        "date || credit || debit || balance\n" \
        "14/01/2023 || || 500.00 || 2500.00\n" \
        "13/01/2023 || 2000.00 || || 3000.00\n" \
        '10/01/2023 || 1000.00 || || 1000.00'
      )
      printer = StatementPrinter.new(fake_io)

      printer.print_statement(account)
    end
  end
end
