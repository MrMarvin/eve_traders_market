class Evecache::MarketList

  def top_buy_orders(num=10)
    buy_orders.sort_by {|h| -h[:price]}[0..num]
  end

  def top_sell_orders(num=10)
    sell_orders.sort_by {|h| h[:price]}[0..num]
  end

end

class FilteredMarketList < Evecache::MarketList

  attr_accessor :bo, :so

  @bo = nil
  @so = nil

  def initialize
    super
  end

  def self.filter(evecache_market_list_obj, &block)
    obj = self.new
    obj.bo= evecache_market_list_obj.buy_orders
    obj.bo.collect! &block if block_given?
    obj.so = evecache_market_list_obj.sell_orders
    obj.so.collect! &block if block_given?
    obj
  end

end