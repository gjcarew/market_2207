class Vendor
  attr_reader :name, :inventory

  def initialize(name)
    @name = name
    @inventory = Hash.new(0)
  end

  def check_stock(item)
    @inventory[item]
  end

  def stock(item, quantity)
    @inventory[item] += quantity
  end

  def potential_revenue
    per_item_revenue = @inventory.map do |item, quantity|
      item.price * quantity
    end
    per_item_revenue.sum
  end
end
