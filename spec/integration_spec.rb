# frozen_string_literal: true

require 'bank_account'
require 'statement_printer'
require 'transfer'

RSpec.describe 'integration' do
  let(:fake_io) { double :fake_io }

  let(:account) do
    fake_time_class = double :fake_time_class
    allow(fake_time_class).to receive(:now).and_return(
      Time.new(2023, 1, 10),
      Time.new(2023, 1, 13),
      Time.new(2023, 1, 14)
    )
    BankAccount.new(time: fake_time_class)
  end

  let(:print_statement) do
    printer = StatementPrinter.new(fake_io)
    printer.print_statement(account)
  end

  context 'when the client sets up an account' do
    it 'prints an empty bank statement' do
      expect(fake_io).to receive(:puts).with(
        'date || credit || debit || balance'
      )
      print_statement
    end
  end

  context 'when the client makes a deposit' do
    it 'prints the statement including the deposit with a total' do
      account.deposit(1000)

      expect(fake_io).to receive(:puts).with(
        "date || credit || debit || balance\n" \
          '10/01/2023 || 1000.00 || || 1000.00'
      )
      print_statement
    end
  end

  context 'when the client makes a withdrawal' do
    it 'prints the statement including the withdrawal with a total' do
      account.withdraw(500)

      expect(fake_io).to receive(:puts).with(
        "date || credit || debit || balance\n" \
        '10/01/2023 || || 500.00 || -500.00'
      )
      print_statement
    end
  end

  context 'when a client makes multiple transfers' do
    it 'prints the statement including all transfers and running totals' do
      account.deposit(1000)
      account.deposit(2000)
      account.withdraw(500)

      expect(fake_io).to receive(:puts).with(
        "date || credit || debit || balance\n" \
        "14/01/2023 || || 500.00 || 2500.00\n" \
        "13/01/2023 || 2000.00 || || 3000.00\n" \
        '10/01/2023 || 1000.00 || || 1000.00'
      )
      print_statement
    end
  end
end
