require 'transfer_formatter'

RSpec.describe TransferFormatter do
  let(:formatter) { TransferFormatter.new }

  let(:fake_transfer1) do
    double :fake_transfer1, {
      deposit?: true,
      withdrawal?: false,
      timestamp: Time.new(2023, 1, 10),
      amount: 1000
    }
  end

  let(:fake_transfer2) do
    double :fake_transfer2, {
      deposit?: false,
      withdrawal?: true,
      timestamp: Time.new(2023, 1, 14),
      amount: -500
    }
  end

  let(:fake_transfer3) do
    double :fake_transfer3, {
      deposit?: true,
      withdrawal?: false,
      timestamp: Time.new(2023, 1, 13),
      amount: 2000
    }
  end

  it 'has fields accessible from outside the class' do
    expect(formatter.field_names).to eq ['date', 'credit', 'debit', 'balance']
  end
  
  describe '#format_one' do
    it 'formats a deposit with a balance into an array' do
      result = formatter.format_one(fake_transfer1, 300)
      expect(result).to eq(['10/01/2023', '1000.00', nil, '300.00'])
    end
    
    it 'formats a withdrawal with a balance into an array' do
      result = formatter.format_one(fake_transfer2, 5000)
      expect(result).to eq(['14/01/2023', nil, '500.00', '5000.00'])
    end
  end

  describe '#format_many' do
    it 'formats many transfers into a two-dimensional array, ordered chronologically' do
      transfers = [fake_transfer1, fake_transfer2, fake_transfer3]
      
      result = formatter.format_many(transfers, 0)
      expected_result = [
        ['10/01/2023', '1000.00', nil, '1000.00'],
        ['13/01/2023', '2000.00', nil, '3000.00'],
        ['14/01/2023', nil, '500.00', '2500.00']
      ]
      expect(result).to eq expected_result
    end
  end
end