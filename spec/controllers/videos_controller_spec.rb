require 'spec_helper'

describe VideosController do
  describe "GET show" do
    let(:user) { Fabricate(:user) }
    it "finds a Video based on given name" do
      session[:user_id] = user.id
      monk = Video.create(title: "Monk", description: "a drama series")
      get :show, id: monk.id
      expect(assigns(:video)).to eq(monk)
    end
    it "renders the show template"
  end
end
