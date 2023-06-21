require 'statement_printer'

RSpec.describe StatementPrinter do
  let(:fake_io) { double :fake_io }

  let(:printer) { printer = StatementPrinter.new(fake_io) }
  
  let(:fake_bank_account) { double :fake_bank_account, starting_balance: 0 }
  
  let(:fake_transfer1) {
    double :fake_transfer1, {
      deposit?: true,
      withdrawal?: false,
      timestamp: Time.new(2023, 1, 10),
      amount: 1000
    }
  }
  
  let(:fake_transfer2) {
    double :fake_transfer2, {
      deposit?: true,
      withdrawal?: false,
      timestamp: Time.new(2023, 1, 13),
      amount: 2000
    }
  }

  let(:fake_transfer3) {
    double :fake_transfer3, {
      deposit?: false,
      withdrawal?: true,
      timestamp: Time.new(2023, 1, 14),
      amount: -500
    }
  }

  context 'when the account has no transfers' do
    it 'generates an empty bank statement' do
      allow(fake_bank_account).to receive(:transfers).and_return([])

      expect(printer.generate_statement(fake_bank_account)).to eq (
        'date || credit || debit || balance'
      )
    end
  end

  context 'when the account has a deposit' do
    it 'generates a bank statement with the deposit and current total' do
      allow(fake_bank_account).to receive(:transfers).and_return(
        [fake_transfer1]
      )

      expect(printer.generate_statement(fake_bank_account)).to eq (
        "date || credit || debit || balance\n" \
          '10/01/2023 || 1000.00 || || 1000.00'
      )
    end
  end

  context 'when the account has a withdrawal' do
    it 'generates a bank statement with the withdrawal and current total' do
      allow(fake_bank_account).to receive(:transfers).and_return(
        [fake_transfer3]
      )

      expect(printer.generate_statement(fake_bank_account)).to eq (
        "date || credit || debit || balance\n" \
          '14/01/2023 || || 500.00 || -500.00'
      )
    end
  end

  context 'when the account has multiple transfers' do
    it 'generates a bank statement with all the transfers' do
      allow(fake_bank_account).to receive(:transfers).and_return(
        [fake_transfer1, fake_transfer2, fake_transfer3]
      )

      expect(printer.generate_statement(fake_bank_account)).to eq (
        "date || credit || debit || balance\n" \
          "14/01/2023 || || 500.00 || 2500.00\n" \
          "13/01/2023 || 2000.00 || || 3000.00\n" \
          '10/01/2023 || 1000.00 || || 1000.00'
      )
    end
  end

  it 'generates the statement and then prints it out' do
    allow(fake_bank_account).to receive(:transfers).and_return(
      [fake_transfer1, fake_transfer2, fake_transfer3]
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
