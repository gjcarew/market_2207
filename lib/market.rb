class Market
  attr_reader :name, :vendors

  def initialize(name)
    @name = name
    @vendors = []
  end

  def add_vendor(vendor)
    @vendors << vendor
  end

  def vendor_names
    @vendors.map{ |vendor| vendor.name}
  end

  def vendors_that_sell(item)
    @vendors.select do |vendor|
      vendor.check_stock(item) != 0
    end
  end

  def total_inventory
    total_quantities = Hash.new(0)
    @vendors.each do |vendor|
      vendor.inventory.each do |item, quantity|
        total_quantities[item] += quantity
      end
    end

    full_inventory = Hash.new
    total_quantities.each do |item, quantity|
      full_inventory[item] = {
        quantity: quantity,
        vendors: vendors_that_sell(item)
      }
    end
    full_inventory
  end

  def overstocked_items
    total_inventory.select do |item, hash|
      hash[:quantity] > 50 && hash[:vendors].length > 1
    end.keys
  end

  def sorted_item_list
    total_inventory.keys.map {|item| item.name}.sort
  end

end
