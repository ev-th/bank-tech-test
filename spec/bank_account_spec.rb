require 'bank_account'

RSpec.describe BankAccount do
  let(:fake_time_object) { double :fake_time_object }

  let(:transfers) {
    [double(:transfer1), double(:transfer2), double(:transfer3)]
  }

  let(:fake_transfer_class) {
    fake_transfer_class = double :fake_transfer_class
    allow(fake_transfer_class).to receive(:new).and_return(
      transfers[0], transfers[1], transfers[2]
    )
    fake_transfer_class
  }

  let(:account) {
    fake_time_class = double :fake_time_class, now: fake_time_object
    BankAccount.new(transfer: fake_transfer_class, time: fake_time_class)
  }

  context 'when the client sets up an account' do
    it 'has no transfers' do
      expect(account.transfers).to eq []
    end

    it 'has a starting balance of 0' do
      expect(account.starting_balance).to eq 0
    end
  end

  context 'when a client makes a deposit' do
    it 'adds a transfer with a positive amount to the list of transfers' do
      expect(fake_transfer_class).to receive(:new).with(1000, fake_time_object)
      account.deposit(1000)
      expect(account.transfers).to eq [transfers[0]]
    end 
  end
  
  context 'when a client makes a withdrawal' do
    it 'adds a transfer with a negative amount to the list of transfers' do
      expect(fake_transfer_class).to receive(:new).with(-500, fake_time_object)
      account.withdraw(500)
      expect(account.transfers).to eq [transfers[0]]
    end 
  end
  
  context 'when a client makes multiple deposits and withdrawals' do
    it 'adds them all to the list of transfers' do
      expect(fake_transfer_class).to receive(:new).with(1000, fake_time_object)
      expect(fake_transfer_class).to receive(:new).with(2000, fake_time_object)
      expect(fake_transfer_class).to receive(:new).with(-500, fake_time_object)

      account.deposit(1000)
      account.deposit(2000)
      account.withdraw(500)

      expect(account.transfers).to eq transfers
    end
  end
end
