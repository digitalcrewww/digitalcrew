require 'rails_helper'

RSpec.describe Admin::PirepsController, type: :controller do
  let(:admin_pilot) { create(:user) }
  let(:regular_pilot) { create(:user) }
  let(:fleet) { create(:fleet) }
  let(:multiplier) { create(:multiplier) }
  let(:pirep) { create(:pirep, user: regular_pilot, status: 'pending') }
  let(:valid_attributes) do
    {
      flight_number: 'FL123',
      flight_date: Date.current,
      departure_icao: 'LFPG',
      arrival_icao: 'EGLL',
      fuel_used: 5000,
      cargo: 1000,
      fleet_id: fleet.id,
      multiplier_id: multiplier.id,
      flight_hours: 1,
      flight_minutes: 0,
      remarks: 'Test flight',
      status: 'pending'
    }
  end
  let(:invalid_attributes) { { flight_number: '' } }
  let(:session_id) { SessionManager.create_session(admin_pilot, request)[:value] }

  before do
    allow(SetupStatusService).to receive(:completed?).and_return(true)
    allow(SessionManager).to receive(:fetch_user_from_session).with(session_id).and_return(admin_pilot)
    allow(controller).to receive(:current_user).and_return(admin_pilot)
    cookies.signed[:session_id] = session_id
  end

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end

    it "assigns all pireps as @pireps grouped by status" do
      pending_pirep = create(:pirep, status: 'pending')
      approved_pirep = create(:pirep, status: 'approved')
      rejected_pirep = create(:pirep, status: 'rejected')

      get :index

      expect(assigns(:pireps)['pending']).to include(pending_pirep)
      expect(assigns(:pireps)['approved']).to include(approved_pirep)
      expect(assigns(:pireps)['rejected']).to include(rejected_pirep)
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: pirep.to_param }
      expect(response).to be_successful
    end
  end

  describe "PATCH #approve" do
    it "approves the requested pirep" do
      patch :approve, params: { id: pirep.to_param }
      pirep.reload
      expect(pirep.status).to eq('approved')
    end

    it "redirects to the pireps list" do
      patch :approve, params: { id: pirep.to_param }
      expect(response).to redirect_to(admin_pireps_path)
    end

    it "updates the user's flight time" do
      expect {
        patch :approve, params: { id: pirep.to_param }
        regular_pilot.reload
      }.to change(regular_pilot, :flight_time).by(pirep.flight_time_minutes)
    end
  end

  describe "PATCH #reject" do
    let(:approved_pirep) { create(:pirep, user: regular_pilot, status: 'approved') }

    it "rejects the requested pirep" do
      patch :reject, params: { id: approved_pirep.to_param }
      approved_pirep.reload
      expect(approved_pirep.status).to eq('rejected')
    end

    it "redirects to the pireps list" do
      patch :reject, params: { id: approved_pirep.to_param }
      expect(response).to redirect_to(admin_pireps_path)
    end

    it "updates the user's flight time" do
      approved_pirep.update(status: 'approved')
      regular_pilot.increment!(:flight_time, approved_pirep.flight_time_minutes)
      regular_pilot.reload
      expect {
        patch :reject, params: { id: approved_pirep.to_param }
        regular_pilot.reload
      }.to change(regular_pilot, :flight_time).by(-approved_pirep.flight_time_minutes)
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested pirep" do
      pirep = create(:pirep)
      expect {
        delete :destroy, params: { id: pirep.to_param }
      }.to change(Pirep, :count).by(-1)
    end

    it "redirects to the pireps list" do
      delete :destroy, params: { id: pirep.to_param }
      expect(response).to redirect_to(admin_pireps_path)
    end
  end
end
