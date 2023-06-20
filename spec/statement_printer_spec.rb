require 'statement_printer'

RSpec.describe StatementPrinter do
  context "when the account has no transfers" do
    it 'generates an empty bank statement' do
      fake_bank_account = double :fake_bank_account, starting_balance: 0
      allow(fake_bank_account).to receive(:transfers).and_return([])
      printer = StatementPrinter.new

      statement = printer.generate_statement(fake_bank_account)
      expected_result = 'date || credit || debit || balance'

      expect(statement).to eq expected_result
    end
  end

  context "when the account has a deposit" do
    it 'generates a bank statement with the deposit and current total' do      
      stubs = {
        deposit?: true,
        withdrawal?: false,
        timestamp: Time.new(2023, 1, 10),
        amount: 1000
      }
      fake_deposit = double :fake_deposit, stubs

      fake_bank_account = double :fake_bank_account, starting_balance: 0
      allow(fake_bank_account).to receive(:transfers).and_return([fake_deposit])
      
      printer = StatementPrinter.new
      
      statement = printer.generate_statement(fake_bank_account)
      expected_result = "date || credit || debit || balance\n" \
      '10/01/2023 || 1000.00 || || 1000.00'
      
      expect(statement).to eq expected_result
    end
  end
  
  context "when the account has a withdrawal" do
    it 'generates a bank statement with the withdrawal and current total' do
      stubs = {
        deposit?: false,
        withdrawal?: true,
        timestamp: Time.new(2023, 1, 14),
        amount: 500
      }
      fake_deposit = double :fake_deposit, stubs
      
      fake_bank_account = double :fake_bank_account, starting_balance: 0
      allow(fake_bank_account).to receive(:transfers).and_return([fake_deposit])
      
      printer = StatementPrinter.new
      
      statement = printer.generate_statement(fake_bank_account)
      expected_result = "date || credit || debit || balance\n" \
      '14/01/2023 || || 500.00 || -500.00'
      
      expect(statement).to eq expected_result
    end
  end
  
  context "when the account has multiple transfers" do
    it 'generates a bank statement with all the transfers' do
      fake_deposit_stubs1 = {
        deposit?: true,
        withdrawal?: false,
        timestamp: Time.new(2023, 1, 10),
        amount: 1000
      }
      fake_deposit1 = double :fake_deposit1, fake_deposit_stubs1

      fake_deposit_stubs2 = {
        deposit?: true,
        withdrawal?: false,
        timestamp: Time.new(2023, 1, 13),
        amount: 2000
      }
      fake_deposit2 = double :fake_deposit2, fake_deposit_stubs2
      
      fake_deposit_stubs3 = {
        deposit?: false,
        withdrawal?: true,
        timestamp: Time.new(2023, 1, 14),
        amount: 500
      }
      fake_deposit3 = double :fake_deposit3, fake_deposit_stubs3
      
      fake_bank_account = double :fake_bank_account, starting_balance: 0
      allow(fake_bank_account).to receive(:transfers).and_return([
        fake_deposit1, fake_deposit2, fake_deposit3
      ])
      printer = StatementPrinter.new
      
      statement = printer.generate_statement(fake_bank_account)
      expected_result = "date || credit || debit || balance\n" \
      "14/01/2023 || || 500.00 || 2500.00\n" \
      "13/01/2023 || 2000.00 || || 3000.00\n" \
      '10/01/2023 || 1000.00 || || 1000.00'
      
      expect(statement).to eq expected_result
    end
  end
  
  it "generates the statement and then prints it out" do
    fake_deposit_stubs1 = {
      deposit?: true,
      withdrawal?: false,
      timestamp: Time.new(2023, 1, 10),
      amount: 1000
    }
    fake_deposit1 = double :fake_deposit1, fake_deposit_stubs1

    fake_deposit_stubs2 = {
      deposit?: true,
      withdrawal?: false,
      timestamp: Time.new(2023, 1, 13),
      amount: 2000
    }
    fake_deposit2 = double :fake_deposit2, fake_deposit_stubs2
    
    fake_deposit_stubs3 = {
      deposit?: false,
      withdrawal?: true,
      timestamp: Time.new(2023, 1, 14),
      amount: 500
    }
    fake_deposit3 = double :fake_deposit3, fake_deposit_stubs3
    
    fake_bank_account = double :fake_bank_account, starting_balance: 0
    allow(fake_bank_account).to receive(:transfers).and_return([
      fake_deposit1, fake_deposit2, fake_deposit3
    ])

    fake_io = double :fake_io
    expect(fake_io).to receive(:puts).with(
      "date || credit || debit || balance\n" \
      "14/01/2023 || || 500.00 || 2500.00\n" \
      "13/01/2023 || 2000.00 || || 3000.00\n" \
      '10/01/2023 || 1000.00 || || 1000.00'
    )
    
    printer = StatementPrinter.new(fake_io)
    printer.print_statement(fake_bank_account)
  end
end