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

  context 'when the client adds a transfer' do
    it 'is added to the list of transfers' do
      bank_account = BankAccount.new
      fake_deposit = double :fake_deposit
      bank_account.add_transfer(fake_deposit)

      expect(bank_account.transfers).to eq [fake_deposit]
    end
  end

  context 'when a client makes multiple transfers' do
    it 'adds them all to the list of transfers' do
      fake_deposit1 = double :fake_deposit1
      fake_deposit2 = double :fake_deposit2
      fake_deposit3 = double :fake_deposit3

      bank_account = BankAccount.new
      bank_account.add_transfer(fake_deposit1)
      bank_account.add_transfer(fake_deposit2)
      bank_account.add_transfer(fake_deposit3)

      expected_result = [fake_deposit1, fake_deposit2, fake_deposit3]

      expect(bank_account.transfers).to eq expected_result
    end
  end
end
