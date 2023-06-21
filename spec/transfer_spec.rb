require 'transfer'

RSpec.describe Transfer do
  it 'fails to initialize with 0' do
    expect { described_class.new(0) }.to raise_error 'The transfer amount cannot be 0'
  end

  it 'stores the money transferred by a deposit' do
    transfer = described_class.new(100)
    expect(transfer.amount).to eq 100
  end

  it 'stores the money transferred by a withdrawal' do
    transfer = described_class.new(-2000)
    expect(transfer.amount).to eq(-2000)
  end

  it 'is a deposit if the amount is positive' do
    transfer = described_class.new(700)
    expect(transfer.deposit?).to eq true
    expect(transfer.withdrawal?).to eq false
  end

  it 'is a withdrawal if the amount is negative' do
    transfer = described_class.new(-3)
    expect(transfer.deposit?).to eq false
    expect(transfer.withdrawal?).to eq true
  end

  it 'takes a Time object to record the date of the the transfer' do
    timestamp = Time.new(2023, 1, 10)
    transfer = described_class.new(100, timestamp)
    expect(transfer.timestamp).to eq timestamp
  end
end
