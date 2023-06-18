require 'bank_account'

RSpec.describe BankAccount do
  context "when the client sets up an account" do
    it "displays an empty bank statement" do
      bank_account = BankAccount.new

      result = bank_account.statement
      expected_result = "date || credit || debit || balance"
      
      expect(result).to eq expected_result
    end
  end
  
  context "when the client makes a deposit" do
    it "shows up on her bank statement with a total" do
      bank_account = BankAccount.new
      date = Time.new(2023, 01, 10)
      bank_account.deposit(1000, date)
      
      result = bank_account.statement
      expected_result = "date || credit || debit || balance\n" +
        "10/01/2023 || 1000.00 || || 1000.00"
      
      expect(result).to eq expected_result
    end
  end
  
  context "when the client makes a withdrawal" do
    it "shows up on her bank statement with a total" do
      bank_account = BankAccount.new
      date = Time.new(2023, 01, 14)
      bank_account.withdrawal(500, date)
      
      result = bank_account.statement
      expected_result = "date || credit || debit || balance\n" +
        "14/01/2023 || || 500.00 || -500.00"

      expect(result).to eq expected_result
    end
  end
  
  context "when a client makes multiple transfers" do
    it "shows all the transfers on the bank statement" do
      bank_account = BankAccount.new
      date1 = Time.new(2023, 01, 10)
      bank_account.deposit(1000, date1)
      date2 = Time.new(2023, 01, 13)
      bank_account.deposit(2000, date2)
      date3 = Time.new(2023, 01, 14)
      bank_account.withdrawal(500, date3)
      
      result = bank_account.statement
      expected_result = "date || credit || debit || balance\n" +
        "14/01/2023 || || 500.00 || 2500.00\n" +
        "13/01/2023 || 2000.00 || || 3000.00\n" +
        "10/01/2023 || 1000.00 || || 1000.00"
    
      expect(result).to eq expected_result
    end
  end
end