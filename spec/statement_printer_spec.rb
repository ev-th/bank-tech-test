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
      fake_bank_account = double :fake_bank_account, starting_balance: 0
      allow(fake_bank_account).to receive(:transfers).and_return([
        {
          date: Time.new(2023, 1, 10),
          credit: 1000,
          debit: 0
        }
      ])
      printer = StatementPrinter.new

      statement = printer.generate_statement(fake_bank_account)
      expected_result = "date || credit || debit || balance\n" \
        '10/01/2023 || 1000.00 || || 1000.00'

      expect(statement).to eq expected_result
    end
  end

  context "when the account has a withdrawal" do
    it 'generates a bank statement with the withdrawal and current total' do
      fake_bank_account = double :fake_bank_account, starting_balance: 0
      allow(fake_bank_account).to receive(:transfers).and_return([
        {
          date: Time.new(2023, 1, 14),
          credit: 0,
          debit: 500
        }
      ])
      printer = StatementPrinter.new

      statement = printer.generate_statement(fake_bank_account)
      expected_result = "date || credit || debit || balance\n" \
        '14/01/2023 || || 500.00 || -500.00'

      expect(statement).to eq expected_result
    end
  end

  context "when the account has multiple transfers" do
    it 'generates a bank statement with all the transfers' do
      fake_bank_account = double :fake_bank_account, starting_balance: 0
      allow(fake_bank_account).to receive(:transfers).and_return([
        {
          date: Time.new(2023, 1, 10),
          credit: 1000,
          debit: 0
        },
        {
          date: Time.new(2023, 1, 13),
          credit: 2000,
          debit: 0
        },
        {
          date: Time.new(2023, 1, 14),
          credit: 0,
          debit: 500
        },
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
end