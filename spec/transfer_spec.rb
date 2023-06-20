require 'transfer'

RSpec.describe Transfer do
  it "stores the money transferred by a deposit" do
    transfer = Transfer.new(100)
    expect(transfer.amount).to eq 100
  end

  it "stores the money transferred by a withdrawal" do
    transfer = Transfer.new(-2000)
    expect(transfer.amount).to eq 2000
  end
end