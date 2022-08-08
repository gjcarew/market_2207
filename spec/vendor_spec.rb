require './lib/vendor'
require './lib/item'

RSpec.describe Vendor do
  before :each do
    @item1 = Item.new({name: 'Peach', price: "$0.75"})
    @item2 = Item.new({name: 'Tomato', price: '$0.50'})
    @vendor = Vendor.new("Rocky Mountain Fresh")
  end

  it 'exists' do
    expect(@vendor).to be_a Vendor
  end

  it "has attributes" do
    expect(@vendor.name).to eq("Rocky Mountain Fresh")
    expect(@vendor.inventory).to eq({})
  end

  it 'initializes without stock' do
    expect(@vendor.check_stock(@item1)).to eq(0)
  end

  it "stocks an item" do
    @vendor.stock(@item1, 30)
    expect(@vendor.check_stock(@item1)).to eq(30)
    expect(@vendor.inventory).to eq({@item1 => 30})
  end

end
