require 'spec_helper'

describe SessionController do

  describe "GET 'create'" do
    it "returns http success" do
      get 'create'
      response.should be_success
    end
  end

  describe "GET 'failure'" do
    it "returns http success" do
      get 'failure'
      response.should be_success
    end
  end

end
