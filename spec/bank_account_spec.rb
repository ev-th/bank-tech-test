require 'bank_account'

RSpec.describe BankAccount do
  context "when the client sets up an account" do
    it "displays an empty bank statement" do
      bank_account = BankAccount.new
      result = bank_account.statement
      expect(result).to eq "date || credit || debit || balance"
    end
  end
end