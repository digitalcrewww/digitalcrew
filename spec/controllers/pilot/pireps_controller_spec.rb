require 'rails_helper'

RSpec.describe Pilot::PirepsController, type: :controller do
  let(:user) { create(:user) }
  let(:fleet) { create(:fleet) }
  let(:multiplier) { create(:multiplier) }
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
      flight_hours: 2,
      flight_minutes: 30,
      remarks: 'Test flight',
      status: 'pending'
    }
  end
  let(:invalid_attributes) { { flight_number: '' } }
  let(:session_id) { SessionManager.create_session(user, request)[:value] }

  before do
    allow(SetupStatusService).to receive(:completed?).and_return(true)
    allow(SessionManager).to receive(:fetch_user_from_session).with(session_id).and_return(user)
    allow(controller).to receive(:current_user).and_return(user)
    cookies.signed[:session_id] = session_id
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns a new Pirep as @pirep' do
      get :index
      expect(assigns(:pirep)).to be_a_new(Pirep)
    end

    it 'assigns all fleets as @fleets' do
      get :index
      expect(assigns(:fleets)).to eq(Fleet.all)
    end

    it 'assigns all multipliers as @multipliers' do
      get :index
      expect(assigns(:multipliers)).to eq(Multiplier.all)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Pirep' do
        expect do
          post :create, params: { pirep: valid_attributes }
        end.to change(Pirep, :count).by(1)
      end

      it 'creates a Pirep associated with the current user' do
        post :create, params: { pirep: valid_attributes }
        expect(Pirep.last.user).to eq(user)
      end

      it 'redirects to the pireps list' do
        post :create, params: { pirep: valid_attributes }
        expect(response).to redirect_to(pireps_path)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'index' template)" do
        post :create, params: { pirep: invalid_attributes }
        expect(response).to be_successful
      end

      it 'does not create a new Pirep' do
        expect do
          post :create, params: { pirep: invalid_attributes }
        end.not_to change(Pirep, :count)
      end

      it 'assigns a newly created but unsaved pirep as @pirep' do
        post :create, params: { pirep: invalid_attributes }
        expect(assigns(:pirep)).to be_a_new(Pirep)
      end

      it 'assigns all fleets as @fleets' do
        post :create, params: { pirep: invalid_attributes }
        expect(assigns(:fleets)).to eq(Fleet.all)
      end

      it 'assigns all multipliers as @multipliers' do
        post :create, params: { pirep: invalid_attributes }
        expect(assigns(:multipliers)).to eq(Multiplier.all)
      end
    end

    context 'security' do
      let(:other_user) { create(:user) }
      let(:security_attributes) { valid_attributes.merge(user_id: other_user.id) }

      it 'does not allow creating a PIREP for another user' do
        expect do
          post :create, params: { pirep: security_attributes }
          end.to change(Pirep, :count).by(1)
          expect(Pirep.last.user).to eq(user)
          expect(Pirep.last.user).not_to eq(other_user)
        end
      end
    end
end
