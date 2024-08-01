require 'rails_helper'

RSpec.describe Admin::FleetController, type: :controller do
  let(:user) { create(:user) }
  let(:aircraft) { create(:aircraft) }
  let(:valid_attributes) { { aircraft_id: aircraft.id, livery: 'Test Livery' } }
  let(:invalid_attributes) { { aircraft_id: nil, livery: '' } }
  let(:session_id) { SessionManager.create_session(user, request)[:value] }

  before do
    allow(SetupStatusService).to receive(:completed?).and_return(true)
    allow(SessionManager).to receive(:fetch_user_from_session).with(session_id).and_return(user)
    cookies.signed[:session_id] = session_id
  end

  describe 'GET #index' do
    it 'returns a success response' do
      Fleet.create! valid_attributes
      get :index
      expect(response).to be_successful
    end

    it 'assigns all fleet items as @fleet' do
      fleet_item = Fleet.create! valid_attributes
      get :index
      expect(assigns(:fleet)).to eq([fleet_item])
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Fleet item' do
        expect do
          post :create, params: { fleet: valid_attributes }
        end.to change(Fleet, :count).by(1)
      end

      it 'redirects to the fleet list' do
        post :create, params: { fleet: valid_attributes }
        expect(response).to redirect_to(admin_fleet_index_path)
      end
    end

    context 'with invalid params' do
      it 'returns a success response (i.e. to display the index template with errors)' do
        post :create, params: { fleet: invalid_attributes }
        expect(response).to be_successful
      end

      it 'does not create a new Fleet item' do
        expect do
          post :create, params: { fleet: invalid_attributes }
        end.to change(Fleet, :count).by(0)
      end
    end
  end

  describe 'PATCH #update' do
    let(:fleet_item) { Fleet.create! valid_attributes }

    context 'with valid params' do
      let(:new_attributes) { { livery: 'New Livery' } }

      it 'updates the requested fleet item' do
        patch :update, params: { id: fleet_item.to_param, fleet: new_attributes }
        fleet_item.reload
        expect(fleet_item.livery).to eq('New Livery')
      end

      it 'renders json of the updated livery' do
        patch :update, params: { id: fleet_item.to_param, fleet: new_attributes }
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(JSON.parse(response.body)['livery']).to eq('New Livery')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the fleet item' do
        patch :update, params: { id: fleet_item.to_param, fleet: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested fleet item' do
      fleet_item = Fleet.create! valid_attributes
      expect do
        delete :destroy, params: { id: fleet_item.to_param }
      end.to change(Fleet, :count).by(-1)
    end

    it 'redirects to the fleet list' do
      fleet_item = Fleet.create! valid_attributes
      delete :destroy, params: { id: fleet_item.to_param }
      expect(response).to redirect_to(admin_fleet_index_path)
    end
  end
end