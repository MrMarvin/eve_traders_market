require 'listen'
require 'evecache'
require 'yaml'

require './data/stations'
require './data/mapregions'
require './data/itemtypes'
require './marketlist'
require './helper'

conf = YAML.load_file "./config/conf.yml"

raise StandardError.new("please give path to cache files as first ARGV") unless ARGV[0] && ARGV[0].include?("CachedMethodCalls")
# /Users/marv/Library/Application Support/EVE Online/p_drive/Local Settings/Application Data/CCP/EVE/c_program_files_ccp_eve_tranquility/cache/MachoNet/87.237.38.200/359/CachedMethodCalls

puts "listening...."
Listen.to!(ARGV[0], :filter => /\.cache$/, :relative_paths => false) do |modified, added, removed|
  (modified.concat(added)).each { |f|
    begin
      market = Evecache.open(f)
      sells = OrderList.new(market.sell_orders)
      buys = OrderList.new(market.buy_orders)

      puts "#{ItemType[market.type].type_name}: #{sells.in("Dodixie").top[0][:price].to_isk} - #{buys.in("Dodixie").top[0][:price].to_isk} = #{(sells.in("Dodixie").top[0][:price] - buys.in("Dodixie").top[0][:price]).to_isk} ~> #{(sells.in("Dodixie").top[0][:price].to_f / buys.in("Dodixie").top[0][:price].to_f).to_s}"
    rescue StandardError
      #puts "however, seems not to be a market order file!"
    end
  }
  
  #removed.each {|r| puts "removed: "+r.split("/").last }
end
