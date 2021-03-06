require 'rails_helper'

RSpec.describe Api::V1::UsersController, :type => :controller do
  
  describe 'GET #show' do
    before(:each) do
      @user = FactoryGirl.create :user
      get :show, id: @user.id, format: :json
    end

    it 'returns the information about a user in a hash' do
      user_response = json_response
      expect(user_response[:email]).to eql @user.email
    end

    it { should respond_with 200 }
  end

  describe 'POST #create' do
    context 'when successfully created' do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for :user
        post :create, { user: @user_attributes }
      end

      it 'renders the created user in json' do
        user_response = json_response
        expect(user_response[:email]).to eql @user_attributes[:email] 
      end

      it { should respond_with 201 }
    end

    context 'when is not created' do
      before(:each) do
        @invalid_user_attributes = { password: '12345678', password_confirmation: '12345678' }
        post :create, { user: @invalid_user_attributes }
      end

      it 'renders an error json' do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it { should respond_with 422 }
    end
  end

  describe 'PUT/PATCH #update' do
    context 'when successfully updated' do 
      before(:each) do
        @user = FactoryGirl.create :user
        api_authorization_header @user.auth_token
        patch :update, { id: @user.id, user: { email: 'funny@gmail.com' } }
      end

      it 'should return success and updated email' do
        user_response = json_response
        expect(user_response[:email]).to eql 'funny@gmail.com' 
      end

      it { should respond_with 200 }
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      @user = FactoryGirl.create :user
      api_authorization_header @user.auth_token
      delete :destroy, { id: @user.id }
    end

    it { should respond_with 204 }
  end
end
