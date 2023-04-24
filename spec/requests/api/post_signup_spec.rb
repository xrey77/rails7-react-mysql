require 'rails_helper'

RSpec.describe "Api::UsersController", type: :request do
    describe "GET /api/users" do
        it "returns http success" do
            post 'http://127.0.0.1:3000/api/signup'
            # expect(response).to have_http_status(200)
            expect(response).to have_http_status(:success)
        end
    end
end

