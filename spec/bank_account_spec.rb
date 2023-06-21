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

  context 'when a client makes a deposit' do
    it 'adds a transfer with a positive amount to the list of transfers' do
      fake_time_object = double :fake_time_object
      fake_time_class = double :fake_time_class, now: fake_time_object
      fake_transfer_object = double :fake_transfer_object
      fake_transfer_class = double :fake_transfer_class, new: fake_transfer_object
      expect(fake_transfer_class).to receive(:new).with(1000, fake_time_object)

      account = BankAccount.new(transfer: fake_transfer_class, time: fake_time_class)
      account.deposit(1000)
      expect(account.transfers).to eq [fake_transfer_object]
    end 
  end
  
  context 'when a client makes a withdrawal' do
    it 'adds a transfer with a negative amount to the list of transfers' do
      fake_time_object = double :fake_time_object
      fake_time_class = double :fake_time_class, now: fake_time_object
      fake_transfer_object = double :fake_transfer_object
      fake_transfer_class = double :fake_transfer_class, new: fake_transfer_object
      expect(fake_transfer_class).to receive(:new).with(-500, fake_time_object)
      
      account = BankAccount.new(transfer: fake_transfer_class, time: fake_time_class)
      account.withdraw(500)
      expect(account.transfers).to eq [fake_transfer_object]
    end 
  end
  
  context 'when a client makes multiple deposits and withdrawals' do
    it 'adds them all to the list of transfers' do
      fake_time_object = double :fake_time_object
      fake_time_class = double :fake_time_class, now: fake_time_object
      transfer1 = double :transfer1
      transfer2 = double :transfer2
      transfer3 = double :transfer3
      fake_transfer_class = double :fake_transfer_class
      allow(fake_transfer_class).to receive(:new).and_return(transfer1, transfer2, transfer3)

      expect(fake_transfer_class).to receive(:new).with(1000, fake_time_object)
      expect(fake_transfer_class).to receive(:new).with(2000, fake_time_object)
      expect(fake_transfer_class).to receive(:new).with(-500, fake_time_object)

      account = BankAccount.new(transfer: fake_transfer_class, time: fake_time_class)
      account.deposit(1000)
      account.deposit(2000)
      account.withdraw(500)
      expect(account.transfers).to eq [transfer1, transfer2, transfer3]
    end
  end
end
