class Fixnum
  def to_isk(with_cents=false)
    # I have no idea why prices are in 1/100 cents...
    (self/10000).to_s+","+(self/100).to_s[-2..-1]+" ISK"
  end
end

class OrderList

  attr_accessor :orders

  def initialize(list)
    @orders = list
  end

  def [](i)
    @orders[i]
  end

  def in(where)    
    where_ids = where.is_a?(Fixnum) ? [where] : Station.find_by_name(where).collect {|s| s.station_id}
    res = self.dup
    res.orders = res.orders.select {|o| where_ids.include? o[:station_id] }
    res
  end
  
  def avg(key=:price)
    @orders.inject(0) {|c,o| c = c+o[key]} / @orders.length
  end

  def top(num=10)
    if @orders.first[:sell_or_buy] == :buy
      # buy orders: descending sort
      self.class.new(@orders.sort_by {|h| -h[:price]}[0..num])
    else
      # sell orders: ascending sort
      self.class.new(@orders.sort_by {|h| h[:price]}[0..num])
    end    
  end

  def count
    @orders.length
  end

end
