require 'bank_account'

RSpec.describe BankAccount do
  context 'when the client sets up an account' do
    it 'has no transfers' do
      bank_account = BankAccount.new

      expect(bank_account.transfers).to eq []
    end

    it 'has a starting balance of 0' do
      bank_account = BankAccount.new

      expect(bank_account.starting_balance).to eq 0
    end
  end

  context 'when the client makes a deposit' do
    it 'is added to the list of transfers' do
      bank_account = BankAccount.new
      date = Time.new(2023, 1, 10)
      bank_account.deposit(1000, date)

      expected_result = [
        {
          date: date,
          credit: 1000,
          debit: 0
        }
      ]
      
      expect(bank_account.transfers).to eq expected_result
    end
  end
  
  context 'when the client makes a withdrawal' do
    it 'is added to the list of transfers' do
      bank_account = BankAccount.new
      date = Time.new(2023, 1, 14)
      bank_account.withdraw(500, date)
      
      expected_result = [
        {
          date: date,
          credit: 0,
          debit: 500
        }
      ]

      expect(bank_account.transfers).to eq expected_result
    end
  end

  context 'when a client makes multiple transfers' do
    it 'adds them all to the list of transfers' do
      bank_account = BankAccount.new
      date1 = Time.new(2023, 1, 10)
      bank_account.deposit(1000, date1)
      date2 = Time.new(2023, 1, 13)
      bank_account.deposit(2000, date2)
      date3 = Time.new(2023, 1, 14)
      bank_account.withdraw(500, date3)

      expected_result = [
        {
          date: date1,
          credit: 1000,
          debit: 0
        },
        {
          date: date2,
          credit: 2000,
          debit: 0
        },
        {
          date: date3,
          credit: 0,
          debit: 500
        },
      ]

      expect(bank_account.transfers).to eq expected_result
    end
  end
end
