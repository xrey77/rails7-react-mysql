require 'rails_helper'

RSpec.describe "Api::ProductsController", type: :request do
    describe "GET /api/products" do
        it "returns http success" do
            get 'http://127.0.0.1:3000/api/getproductdetails/10'
            # expect(response).to have_http_status(200)
            expect(response).to have_http_status(:success)
        end
    end
end

