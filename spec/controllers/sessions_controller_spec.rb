require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { create(:user, password: 'password', is_accepted: true) }

  before do
    allow(SetupStatusService).to receive(:completed?).and_return(true)
  end

  describe 'POST #create' do
    context 'with valid credentials and accepted user' do
      it 'logs in the user' do
        post :create, params: { email: user.email, password: 'password' }
        expect(response).to redirect_to(root_path)
        expect(cookies.signed[:session_id]).to be_present
      end
    end

    context 'with valid credentials but unaccepted user' do
      let(:unaccepted_user) { create(:user, password: 'password', is_accepted: false) }

      it 'does not log in the user' do
        post :create, params: { email: unaccepted_user.email, password: 'password' }
        expect(response).to have_http_status(:unauthorized)
        expect(cookies.signed[:session_id]).to be_nil
      end
    end

    context 'with invalid credentials' do
      it 'renders the new template' do
        post :create, params: { email: user.email, password: 'wrong_password' }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(cookies.signed[:session_id]).to be_nil
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'logs out the user' do
      post :create, params: { email: user.email, password: 'password' }
      session_id = cookies.signed[:session_id]
      expect do
        delete :destroy
      end.to change(Session, :count).by(-1)
      expect(response).to redirect_to(login_path)
      expect(Session.find_by(session_id:)).to be_nil
    end
  end
end
