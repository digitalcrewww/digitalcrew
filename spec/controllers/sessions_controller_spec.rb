require 'rails_helper'

RSpec.describe SessionsController, type: :controller do # rubocop:disable Metrics/BlockLength
  let(:user) { create(:user, password: 'password') }

  describe 'POST #create' do
    context 'with valid credentials' do
      it 'logs in the user' do
        post :create, params: { email: user.email, password: 'password' }
        expect(response).to redirect_to(root_path)
        expect(cookies.signed[:session_id]).to be_present
      end
    end

    context 'with invalid credentials' do
      it 'renders the new template' do
        post :create, params: { email: user.email, password: 'wrong_password' }
        expect(response).to render_template(:new)
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

      expect(response).to redirect_to(root_path)
      expect(Session.find_by(session_id:)).to be_nil
    end
  end
end
