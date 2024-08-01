require 'rails_helper'

RSpec.describe Admin::PilotsController, type: :controller do
  let(:admin) { create(:user, is_accepted: true) }
  let(:session_id) { SessionManager.create_session(admin, request)[:value] }

  before do
    allow(SetupStatusService).to receive(:completed?).and_return(true)
    allow(SessionManager).to receive(:fetch_user_from_session).with(session_id).and_return(admin)
    cookies.signed[:session_id] = session_id
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns unaccepted pilots as @pilots' do
      accepted_pilot = create(:user, is_accepted: true)
      unaccepted_pilot = create(:user, is_accepted: false)
      get :index
      expect(assigns(:pilots)).to eq([unaccepted_pilot])
      expect(assigns(:pilots)).not_to include(accepted_pilot)
    end
  end

  describe 'PATCH #update' do
    let(:unaccepted_pilot) { create(:user, is_accepted: false) }

    it 'accepts the pilot' do
      patch :update, params: { id: unaccepted_pilot.to_param }
      unaccepted_pilot.reload
      expect(unaccepted_pilot.is_accepted).to be true
    end

    it 'redirects to the pilots list' do
      patch :update, params: { id: unaccepted_pilot.to_param }
      expect(response).to redirect_to(admin_pilots_path)
    end
  end

  describe 'DELETE #destroy' do
    let!(:pilot) { create(:user, is_accepted: false) }

    it 'destroys the requested pilot' do
      expect do
        delete :destroy, params: { id: pilot.to_param }
      end.to change(User, :count).by(-1)
    end

    it 'redirects to the pilots list' do
      delete :destroy, params: { id: pilot.to_param }
      expect(response).to redirect_to(admin_pilots_path)
    end
  end
end