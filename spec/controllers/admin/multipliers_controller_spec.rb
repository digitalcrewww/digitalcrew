require 'rails_helper'

RSpec.describe Admin::MultipliersController, type: :controller do
  let(:user) { create(:user) }
  let(:valid_attributes) { { name: 'Test Multiplier', value: 1.5 } }
  let(:invalid_attributes) { { name: '', value: nil } }
  let(:session_id) { SessionManager.create_session(user, request)[:value] }

  before do
    allow(SetupStatusService).to receive(:completed?).and_return(true)
    allow(SessionManager).to receive(:fetch_user_from_session).with(session_id).and_return(user)
    cookies.signed[:session_id] = session_id
  end

  describe 'GET #index' do
    it 'returns a success response' do
      Multiplier.create! valid_attributes
      get :index
      expect(response).to be_successful
    end

    it 'assigns all multipliers as @multipliers' do
      multiplier = Multiplier.create! valid_attributes
      get :index
      expect(assigns(:multipliers)).to eq([multiplier])
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Multiplier' do
        expect do
          post :create, params: { multiplier: valid_attributes }
        end.to change(Multiplier, :count).by(1)
      end

      it 'redirects to the multipliers list' do
        post :create, params: { multiplier: valid_attributes }
        expect(response).to redirect_to(admin_multipliers_path)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { multiplier: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid params' do
      let(:new_attributes) { { value: 2.0 } }

      it 'updates the requested multiplier' do
        multiplier = Multiplier.create! valid_attributes
        patch :update, params: { id: multiplier.to_param, multiplier: new_attributes }
        multiplier.reload
        expect(multiplier.value).to eq(2.0)
      end

      it 'renders json of the updated value' do
        multiplier = Multiplier.create! valid_attributes
        patch :update, params: { id: multiplier.to_param, multiplier: new_attributes }
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(JSON.parse(response.body)['value']).to eq(2.0)
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the multiplier' do
        multiplier = Multiplier.create! valid_attributes
        patch :update, params: { id: multiplier.to_param, multiplier: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested multiplier' do
      multiplier = Multiplier.create! valid_attributes
      expect do
        delete :destroy, params: { id: multiplier.to_param }
      end.to change(Multiplier, :count).by(-1)
    end

    it 'redirects to the multipliers list' do
      multiplier = Multiplier.create! valid_attributes
      delete :destroy, params: { id: multiplier.to_param }
      expect(response).to redirect_to(admin_multipliers_path)
    end
  end
end