require 'bank_account'

RSpec.describe BankAccount do
  context "when the client sets up an account" do
    it "displays an empty bank statement" do
      bank_account = BankAccount.new
      result = bank_account.statement
      expect(result).to eq "date || credit || debit || balance"
    end
  end
  
  context "when the client makes a deposit" do
    it "shows up on her bank statement with a total" do
      bank_account = BankAccount.new
      time = Time.new(2023, 01, 10)
      bank_account.deposit(1000, time)
      result = bank_account.statement
      expect(result).to eq "date || credit || debit || balance\n10/01/2023 || 1000.00 || || 1000.00"
    end
  end
end