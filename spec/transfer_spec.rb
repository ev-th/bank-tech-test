# frozen_string_literal: true

require 'transfer'

RSpec.describe Transfer do
  context 'when passed 0' do
    it 'fails to initialize' do
      expect { described_class.new(0) }.to raise_error 'The transfer amount cannot be 0'
    end
  end

  context 'when passed a positive amount' do
    it 'stores that amount' do
      transfer = described_class.new(100)
      expect(transfer.amount).to eq 100
    end

    it 'is a deposit' do
      transfer = described_class.new(700)
      expect(transfer.deposit?).to eq true
      expect(transfer.withdrawal?).to eq false
    end
  end

  context 'when passed a negative amount' do
    it 'stores that negative amount' do
      transfer = described_class.new(-2000)
      expect(transfer.amount).to eq(-2000)
    end

    it 'is a withdrawal' do
      transfer = described_class.new(-3)
      expect(transfer.deposit?).to eq false
      expect(transfer.withdrawal?).to eq true
    end
  end

  context 'when passed an optional time object' do
    it 'stores it as a timestamp' do
      timestamp = Time.new(2023, 1, 10)
      transfer = described_class.new(100, timestamp)
      expect(transfer.timestamp).to eq timestamp
    end
  end
end
