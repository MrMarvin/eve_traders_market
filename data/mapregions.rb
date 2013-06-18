require 'csv'

class MapRegion

  attr_accessor :region_id, :region_name

  @@map_regions = {}

  def self.load_from_file(path)
    begin
      CSV.foreach(path, {col_sep: ";", headers: true}) do |row|
        @@map_regions[row[0].to_i] = self.new(row[0].to_i, row[1])
      end
    rescue CSV::MalformedCSVError
      #trololol do nothing, we have all data, dont care if the newlines are windows mess or whatever
    end
  end

  def self.[](key=nil)
    unless key
      @@map_regions
    else
      @@map_regions[key]
    end
  end

  def initialize(region_id, region_name)
    self.region_id = region_id
    self.region_name = region_name
  end

  def self.find_by_name(name)
    @@map_regions.values.collect { |v| v if v.region_name.include? name }.compact
  end
end

MapRegion.load_from_file "./data/mapRegions.csv"