require 'bank_account'
require 'statement_printer'

RSpec.describe BankAccount do
  context 'when the client sets up an account' do
    xit 'prints an empty bank statement' do
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
    xit 'prints the statement including the deposit with a total' do
      account = BankAccount.new
      date = Time.new(2023, 1, 10)
      account.deposit(1000, date)

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
    xit 'prints the statement including the withdrawal with a total' do
      account = BankAccount.new
      date = Time.new(2023, 1, 14)
      account.withdraw(500, date)
    
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
    xit 'prints the statement including all transfers and running totals' do
      account = BankAccount.new
      date1 = Time.new(2023, 1, 10)
      account.deposit(1000, date1)
      date2 = Time.new(2023, 1, 13)
      account.deposit(2000, date2)
      date3 = Time.new(2023, 1, 14)
      account.withdraw(500, date3)
    
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
