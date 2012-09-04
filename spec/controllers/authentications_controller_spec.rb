require 'spec_helper'

describe AuthenticationsController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'create'" do
    it "returns http success" do
      get 'create'
      response.should be_success
    end
  end

  describe "GET 'destroy'" do
    it "returns http success" do
      get 'destroy'
      response.should be_success
    end
  end

  describe "GET 'create_new_omniauth_user'" do
    it "returns http success" do
      get 'create_new_omniauth_user'
      response.should be_success
    end
  end

end
