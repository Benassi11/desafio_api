require 'rails_helper'
require 'swagger_helper'

RSpec.describe "Users", type: :request do
  path '/auth/sign_in' do
    post 'Logs in the user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: [ 'email', 'password' ]
      }

      response '200', 'User logged in successfully' do
        let(:user) { { email: 'adm@2314.com', password: '123456' } }

        run_test!
      end

      response '401', 'Invalid login credentials' do
        let(:user) { { email: 'exemplo@exemplo.com', password: 'wrong' } }

        run_test!
      end
    end
  end
end
#   path 'users' do
#     get 'user list' do
#       tags 'Users'
#       consumes 'application/json'
#       produces 'application/json'


#       parameter name: :user, in: :header, schema: {
#         type: :object,
#         properties: {
#           uid: {},
#           client: {},
#           access_token: {}
#         },
#         required: [ 'uid', 'client', 'access_token' ]
#       }
#       end
#     end
#   end
# end
