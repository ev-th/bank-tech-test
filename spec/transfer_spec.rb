require 'transfer'

RSpec.describe Transfer do
  it 'fails to initialize with 0' do
    expect { Transfer.new(0) }.to raise_error 'The transfer amount cannot be 0'
  end

  it 'stores the money transferred by a deposit' do
    transfer = Transfer.new(100)
    expect(transfer.amount).to eq 100
  end

  it 'stores the money transferred by a withdrawal' do
    transfer = Transfer.new(-2000)
    expect(transfer.amount).to eq 2000
  end

  it 'is a deposit if passed a positive number' do
    transfer = Transfer.new(700)
    expect(transfer.deposit?).to eq true
    expect(transfer.withdrawal?).to eq false
  end

  it 'is a withdrawal if passed a negative number' do
    transfer = Transfer.new(-3)
    expect(transfer.deposit?).to eq false
    expect(transfer.withdrawal?).to eq true
  end

  it 'takes a Time object to record the date of the the transfer' do
    timestamp = Time.new(2023, 1, 10)
    transfer = Transfer.new(100, timestamp)

    expect(transfer.timestamp).to eq timestamp
  end
end
