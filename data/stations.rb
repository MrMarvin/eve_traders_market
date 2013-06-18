require 'csv'

class Station

  attr_accessor :station_id, :station_name

  @@stations = {}

  def self.load_from_file(path)
    begin
      CSV.foreach(path, {col_sep: ";", headers: true}) do |row|
        @@stations[row[0].to_i] = self.new(row[0].to_i, row[11])
      end
    rescue CSV::MalformedCSVError
      #trololol do nothing, we have all data, dont care if the newlines are windows mess or whatever
    end
  end

  def self.[](key=nil)
    unless key
      @@stations
    else
      @@stations[key]
    end
  end

  def initialize(station_id, station_name)
    self.station_id = station_id
    self.station_name = station_name
  end

  def self.find_by_name(name)
    @@stations.values.collect { |v| v if v.station_name.include? name }.compact
  end
end

Station.load_from_file "./data/staStations.csv"