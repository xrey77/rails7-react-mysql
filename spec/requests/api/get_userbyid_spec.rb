require 'rails_helper'

RSpec.describe "Api::UsersController", type: :request do
    describe "GET /api/users" do
        it "returns http success" do
            get 'http://127.0.0.1:3000/api/getuserbyid/2'
            # expect(response).to have_http_status(200)
            expect(response).to have_http_status(:success)
        end
    end
end

