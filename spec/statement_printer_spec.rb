require 'statement_printer'

RSpec.describe StatementPrinter do
  context "when the account has no transfers" do
    it 'generates an empty bank statement' do
      fake_bank_account = double :fake_bank_account
      allow(fake_bank_account).to receive(:transfers).and_return([])

      printer = StatementPrinter.new


      statement = printer.generate_statement(fake_bank_account)
      expected_result = 'date || credit || debit || balance'

      expect(statement).to eq expected_result
    end
  end
end