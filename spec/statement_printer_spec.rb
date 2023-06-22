# frozen_string_literal: true

require 'statement_printer'

RSpec.describe StatementPrinter do
  let(:fake_bank_account) { double :fake_bank_account, starting_balance: 0, transfers: nil }

  let(:fake_formatter) do
    double :fake_formatter, {
      field_names: ['date', 'credit', 'debit', 'balance']
    }
  end

  let(:fake_transfers) do
    [double(:fake_transfer1), double(:fake_transfer2), double(:fake_transfer3)]
  end

  let(:fake_io) { double :fake_io }

  subject(:printer) do
    described_class.new(io: fake_io, transfer_formatter: fake_formatter)
  end

  context 'when the account has no transfers' do
    it 'generates an empty bank statement' do
      allow(fake_bank_account).to receive(:transfers).and_return([])
      allow(fake_formatter).to receive(:format_many).and_return([])

      expect(fake_formatter).to receive(:format_many).with([], 0)
      expect(printer.generate_statement(fake_bank_account)).to eq(
        'date || credit || debit || balance'
      )
    end
  end
  
  context 'when the account has a deposit' do
    it 'generates a bank statement with the deposit and current total' do
      allow(fake_bank_account).to receive(:transfers).and_return(
        [fake_transfers[0]]
      )
      allow(fake_formatter).to receive(:format_many).and_return(
        [['10/01/2023', '1000.00', nil, '1000.00']]
      )

      expect(fake_formatter).to receive(:format_many).with([fake_transfers[0]], 0)
      expect(printer.generate_statement(fake_bank_account)).to eq(
        "date || credit || debit || balance\n" \
          '10/01/2023 || 1000.00 || || 1000.00'
      )
    end
  end

  context 'when the account has a withdrawal' do
    it 'generates a bank statement with the withdrawal and current total' do
      allow(fake_bank_account).to receive(:transfers).and_return(
        [fake_transfers[2]]
      )
      allow(fake_formatter).to receive(:format_many).and_return(
        [['14/01/2023', nil, '500.00', '-500.00']]
      )

      expect(fake_formatter).to receive(:format_many).with([fake_transfers[2]], 0)
      expect(printer.generate_statement(fake_bank_account)).to eq(
        "date || credit || debit || balance\n" \
          '14/01/2023 || || 500.00 || -500.00'
      )
    end
  end

  context 'when the account has multiple transfers' do
    it 'generates a bank statement with all the transfers' do
      allow(fake_bank_account).to receive(:transfers).and_return(
        fake_transfers
      )
      allow(fake_formatter).to receive(:format_many).and_return(
        [
          ['10/01/2023', '1000.00', nil, '1000.00'],
          ['13/01/2023', '2000.00', nil, '3000.00'],
          ['14/01/2023', nil, '500.00', '2500.00']
        ]
      )

      expect(fake_formatter).to receive(:format_many).with(fake_transfers, 0)
      expect(printer.generate_statement(fake_bank_account)).to eq(
        "date || credit || debit || balance\n" \
          "14/01/2023 || || 500.00 || 2500.00\n" \
          "13/01/2023 || 2000.00 || || 3000.00\n" \
          '10/01/2023 || 1000.00 || || 1000.00'
      )
    end
  end

  it 'generates the statement and then prints it out' do
    allow(fake_formatter).to receive(:format_many).and_return(
      [
        ['10/01/2023', '1000.00', nil, '1000.00'],
        ['13/01/2023', '2000.00', nil, '3000.00'],
        ['14/01/2023', nil, '500.00', '2500.00']
      ]
    )

    expect(fake_io).to receive(:puts).with(
      "date || credit || debit || balance\n" \
      "14/01/2023 || || 500.00 || 2500.00\n" \
      "13/01/2023 || 2000.00 || || 3000.00\n" \
      '10/01/2023 || 1000.00 || || 1000.00'
    )

    printer.print_statement(fake_bank_account)
  end
end
