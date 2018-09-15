require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  subject(:user) do
    FactoryBot.build(:user)
  end

  describe "GET #new" do
    it "renders the new users template" do
      get :new

      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "logs the user in" do
        post :create, params: {user: {username: user.username, password: user.password}}
        expect(session[:session_token]).to eq(user.session_token)
      end

      it "redirect to user show page" do
        post :create, params: {user: {username: user.username, password: user.password}}
        expect(response).to redirect_to(user_path(user))
      end
    end

    context "with invalid params" do
      it "validates the presence of pw and renders new template w/ errors" do
        post :create, params: {user: {username: user.username, password: user.password}}
        expect(response).to render_template(:new)
        expect(flash[:errors]).to be_present
      end
    end
  end

end
