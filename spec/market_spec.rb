require './lib/item'
require './lib/vendor'
require './lib/market'
require 'date'

RSpec.describe Market do
  before :each do
    @market = Market.new("South Pearl Street Farmers Market")
    @vendor1 = Vendor.new("Rocky Mountain Fresh")
    @item1 = Item.new({name: 'Peach', price: "$0.75"})
    @item2 = Item.new({name: 'Tomato', price: "$0.50"})
    @item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
    @item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})
    @item5 = Item.new({name: 'Onion', price: '$0.25'})
    @vendor2 = Vendor.new("Ba-Nom-a-Nom")
    @vendor3 = Vendor.new("Palisade Peach Shack")

    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3.stock(@item1, 65)
    @vendor3.stock(@item3, 10)
  end

  it 'exists' do
    expect(@market).to be_a Market
  end

  it 'has attributes' do
    expect(@market.name).to eq("South Pearl Street Farmers Market")
    expect(@market.vendors).to eq([])
  end

  it 'can add vendors' do
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)
    expect(@market.vendors).to eq([@vendor1, @vendor2, @vendor3])
  end

  it 'creates an array of vendor names' do
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)
    expect(@market.vendor_names).to eq(["Rocky Mountain Fresh", "Ba-Nom-a-Nom", "Palisade Peach Shack"])
  end

  it 'lists vendors that sell an item' do
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)
    expect(@market.vendors_that_sell(@item1)).to eq([@vendor1, @vendor3])
    expect(@market.vendors_that_sell(@item4)).to eq([@vendor2])
  end

  it 'has a total inventory hash' do
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)
    expect(@market.total_inventory).to be_a Hash
    expect(@market.total_inventory.keys).to all(be_an Item)
    expect(@market.total_inventory.values).to all(be_a Hash)
    expect(@market.total_inventory.values[0].keys).to eq([:quantity, :vendors])
  end

  it 'can tell overstocked items' do
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)
    expect(@market.overstocked_items).to eq([@item1])
  end

  it 'lists items sorted alphabetically' do
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)
    expect(@market.sorted_item_list).to eq(["Banana Nice Cream", "Peach", "Peach-Raspberry Nice Cream", "Tomato"])
  end

  it 'has a date' do
    allow(Date).to receive(:today).and_return Date.new(2020,02,24)
    market_1 = Market.new("new instance to stub date")
    expect(market_1.date).to eq("24/02/2020")
  end

  it '#sells items that are in stock' do
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)
    expect(@market.sell(@item1, 200)).to eq(false)
    expect(@market.sell(@item5, 1)).to eq(false)
    expect(@market.sell(@item4, 5)).to eq(true)
  end

  it 'reduces stock of sold items' do
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)
    @market.sell(@item4, 5)
    expect(@vendor2).check_stock(@item4).to eq(45)
    @market.sell(@item1, 40)
    expect(@vendor1.check_stock(@item1)).to eq(0)
    expect(@vendor3.check_stock(@item1)).to eq(60)
  end

  end



end
