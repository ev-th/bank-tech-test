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
    it 'generates an bank statement with the deposit and current total' do
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
end