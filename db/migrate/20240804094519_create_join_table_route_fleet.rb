class CreateJoinTableRouteFleet < ActiveRecord::Migration[7.1]
  def change
    create_join_table :routes, :fleets do |t|
      t.index %i[route_id fleet_id], unique: true
      t.index %i[fleet_id route_id]
    end
  end
end
