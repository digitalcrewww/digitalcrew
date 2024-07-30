require 'rails_helper'

RSpec.describe SetupController, type: :controller do
  let(:valid_user_params) { attributes_for(:user) }
  let(:valid_setting_params) { attributes_for(:setting).except(:airline_owner) }
  let(:valid_params) { { user: valid_user_params, setting: valid_setting_params } }

  describe 'GET #new' do
    context 'when setup is not completed' do
      before do
        allow(SetupStatusService).to receive(:completed?).and_return(false)
      end

      it 'returns a success response' do
        get :new
        expect(response).to be_successful
      end

      it 'assigns new User and Setting instances' do
        get :new
        expect(assigns(:user)).to be_a_new(User)
        expect(assigns(:setting)).to be_a_new(Setting)
      end
    end

    context 'when setup is completed' do
      before do
        allow(SetupStatusService).to receive(:completed?).and_return(true)
      end

      it 'redirects to root path' do
        get :new
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      before do
        allow(SetupStatusService).to receive(:completed?).and_return(false)
      end

      it 'creates a new User and Setting' do
        expect do
          post :create, params: valid_params
        end.to change(User, :count).by(1).and change(Setting, :count).by(1)
      end

      it 'redirects to the root path' do
        post :create, params: valid_params
        expect(response).to redirect_to(root_path)
      end

      it 'marks setup as completed' do
        expect(SetupStatusService).to receive(:mark_as_completed)
        post :create, params: valid_params
      end
    end

    context 'with invalid params' do
      let(:invalid_params) { { user: { username: '' }, setting: { airline_name: '' } } }

      before do
        allow(SetupStatusService).to receive(:completed?).and_return(false)
      end

      it 'does not create a new User or Setting' do
        expect do
          post :create, params: invalid_params
        end.to_not change(User, :count)

        expect do
          post :create, params: invalid_params
        end.to_not change(Setting, :count)
      end

      it 'returns an unprocessable entity status' do
        post :create, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'assigns a newly created but unsaved user and setting' do
        post :create, params: invalid_params
        expect(assigns(:user)).to be_a_new(User)
        expect(assigns(:setting)).to be_a_new(Setting)
      end
    end

    context 'when setup is already completed' do
      before do
        allow(SetupStatusService).to receive(:completed?).and_return(true)
      end

      it 'redirects to root path' do
        post :create, params: valid_params
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
