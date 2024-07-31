class AircraftSeederService
  AIRCRAFT_DATA = [
    { name: 'Airbus A220-300', icao_code: 'BCS3' },
    { name: 'Airbus A320', icao_code: 'A320' },
    { name: 'Airbus A330-200', icao_code: 'A332' }
    # Will add more aircraft later
  ].freeze

  def self.seed
    AIRCRAFT_DATA.each do |aircraft|
      Aircraft.find_or_create_by!(icao_code: aircraft[:icao_code]) do |new_aircraft|
        new_aircraft.name = aircraft[:name]
      end
    end
  end
end
