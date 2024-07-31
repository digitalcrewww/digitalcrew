namespace :db do
  desc 'Seed aircraft table with predefined data'
  task seed_aircraft: :environment do
    AircraftSeederService.seed
  end
end
