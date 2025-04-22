require 'rails_helper'
require 'swagger_helper'

RSpec.describe "Users", type: :request do
  
  let(:user_admin) {create(:user, password: '123456', password_confirmation: '123456', is_admin:true) }
  let(:auth_token) { user_admin.create_new_auth_token }
  let(:'access-token') { auth_token['access-token'] }
  let(:client) { auth_token['client'] }
  let(:uid) { auth_token['uid'] }

  path '/auth/sign_in' do
    post 'Logs in the user' do
      tags 'Sign_in'
      consumes 'application/json'
      produces 'application/json'
      let(:create_user) {create(:user, email:'superexemplo@exemplo.com', password: '123456', password_confirmation: '123456', is_admin:true) }

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: [ 'email', 'password' ]
      }
      response '200', 'User logged in successfully' do
        let(:user) { { email:'superexemplo@exemplo.com', password: '123456' } }

        run_test! 
      end

      response '401', 'Invalid login credentials' do
        let(:user) { { email: 'exemplo@exemplo.com', password: 'wrong' } }

        run_test!
      end
    end
  end

  path '/users' do
    get 'User list' do
      tags 'Users'
      produces 'application/json'
       parameter name: 'access-token', in: :header, type: :string, description: 'Token'
        parameter name: 'client', in: :header, type: :string, description: 'Client ID'
        parameter name: 'uid', in: :header, type: :string, description: 'User ID'

      response '200', 'User list returned successfully' do

        run_test!
      end

      response '401', 'No token provided' do
        let(:'access-token') {nil}
        let(:client) {nil}
        let(:uid) {nil }
      
        run_test!
        
      end

      response '403', 'non-admin user' do
        let(:user) {create(:user, password: '123456', password_confirmation: '123456', is_admin:false) }
        let(:auth_token) { user.create_new_auth_token }
        let(:'access-token') { auth_token['access-token'] }
        let(:client) { auth_token['client'] }
        let(:uid) { auth_token['uid'] }
        run_test!
      end
    end
  end

  path '/users/{id}' do
    get 'returns the user' do
      tags 'Users'
      produces 'application/json'
      consumes 'application/json'
       parameter name: 'access-token', in: :header, type: :string, description: 'Token'
        parameter name: 'client', in: :header, type: :string, description: 'Client ID'
        parameter name: 'uid', in: :header, type: :string, description: 'User ID'
        parameter name: 'id', in: :path, type: :string, description: 'user_id' 

        let(:id) { user_admin.id }

      response '200', 'User returned successfully' do

        run_test!
      end

      response '401', 'No token provided' do
        let(:'access-token') {nil}
        let(:client) {nil}
        let(:uid) {nil}
      
        run_test!
        
      end

      response '403', 'non-admin user' do
        let(:user) {create(:user, password: '123456', password_confirmation: '123456', is_admin:false) }
        let(:auth_token) { user.create_new_auth_token }
        let(:'access-token') { auth_token['access-token'] }
        let(:client) { auth_token['client'] }
        let(:uid) { auth_token['uid'] }
        run_test!
      end
    end
  end

  path '/users' do
    post 'Create user' do
      tags 'Users'
      produces 'application/json'
      consumes 'application/json'
       parameter name: 'access-token', in: :header, type: :string, description: 'Token'
        parameter name: 'client', in: :header, type: :string, description: 'Client ID'
        parameter name: 'uid', in: :header, type: :string, description: 'User ID'

        parameter name: :create_user, in: :body, schema: {
          type: :object,
          properties: {
            email: { type: :string },
            password: { type: :string },
            password_confirmation: { type: :string }

          },
          required: [ 'email', 'password', 'password_confirmation' ]
        }

        

      response '201', 'User create successfully' do
        let(:create_user) { { email:'superexemplo@exemplo123123123.com', password: '123456', password_confirmation: '123456' } }
        run_test!
      end

      response '401', 'No token provided' do
        let(:'access-token') {nil}
        let(:client) {nil}
        let(:uid) {nil }
        let(:user) {}
        let(:create_user) {}
      
        run_test!
        
      end

      response '403', 'non-admin user' do
        let(:user) {create(:user, password: '123456', password_confirmation: '123456', is_admin:false) }
        let(:auth_token) { user.create_new_auth_token }
        let(:'access-token') { auth_token['access-token'] }
        let(:client) { auth_token['client'] }
        let(:uid) { auth_token['uid'] }
        let(:create_user) {}

        run_test!
      end
    end 
  end
  
  path '/users/{id}' do
    patch 'Update user' do
      tags 'Users'
      produces 'application/json'
      consumes 'application/json'
       parameter name: 'access-token', in: :header, type: :string, description: 'Token'
        parameter name: 'client', in: :header, type: :string, description: 'Client ID'
        parameter name: 'uid', in: :header, type: :string, description: 'User ID'
        parameter name: 'id', in: :path, type: :string, description: 'user_id' 

        parameter name: :update_user, in: :body, schema: {
          type: :object,
          properties: {
            email: { type: :string },
            password: { type: :string },
            name: {type: :string},
            nickname: { type: :string },
            is_admin: { type: :boolean} 

          }
        }
        let(:id) {user_admin.id}

      response '200', 'User update successfully' do
        let(:update_user) { { email:'supermega@miniexemplo.com', nickname: 'nick'} }  
        run_test! do |response|
          expect(user_admin.reload.email).to eq('supermega@miniexemplo.com')
        end
      end

      response '401', 'No token provided' do
        let(:'access-token') {nil}
        let(:client) {nil}
        let(:uid) {nil }
        let(:update_user) {}

        run_test!
        
      end

      response '403', 'non-admin user' do
        let(:user) {create(:user, password: '123456', password_confirmation: '123456', is_admin:false) }
        let(:auth_token) { user.create_new_auth_token }
        let(:'access-token') { auth_token['access-token'] }
        let(:client) { auth_token['client'] }
        let(:uid) { auth_token['uid'] }
        let(:update_user) {}
        run_test!
      end
    end
  end

  path '/users/{id}' do
    delete 'delete user' do
      tags 'Users'
      produces 'application/json'
      consumes 'application/json'
       parameter name: 'access-token', in: :header, type: :string, description: 'Token'
        parameter name: 'client', in: :header, type: :string, description: 'Client ID'
        parameter name: 'uid', in: :header, type: :string, description: 'User ID'
        parameter name: 'id', in: :path, type: :string, description: 'user_id'

        let(:user_delete) {create(:user, password: '123456', password_confirmation: '123456', is_admin:true) }
        let(:id) {user_delete.id}

      response '204', 'delete user successfully' do
      
        run_test!

      end

      response '401', 'No token provided' do
        let(:'access-token') {nil}
        let(:client) {nil}
        let(:uid) {nil }


        run_test!
        
      end

      response '403', 'non-admin user' do
        let(:user) {create(:user, password: '123456', password_confirmation: '123456', is_admin:false) }
        let(:auth_token) { user.create_new_auth_token }
        let(:'access-token') { auth_token['access-token'] }
        let(:client) { auth_token['client'] }
        let(:uid) { auth_token['uid'] }
        run_test!
      end
    end
  end
end