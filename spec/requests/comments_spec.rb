require 'rails_helper'
require 'swagger_helper'

RSpec.describe "/comments", type: :request do
  let(:user_not_admin) { create(:user, password: '123456', password_confirmation: '123456', is_admin: false) }
  let(:auth_token) { user_not_admin.create_new_auth_token }
  let(:'access-token') { auth_token['access-token'] }
  let(:client) { auth_token['client'] }
  let(:uid) { auth_token['uid'] }

  path '/comments' do
    get 'comment list' do
      tags 'Comments'
      consumes 'application/json'
      produces 'application/json'

      response '200', 'comment list successfully' do
        run_test!
      end
    end
  end

  path '/comments/{id}' do
    get 'Show comment' do
      tags 'Comments'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string, required: true, description: 'comment ID'

      let(:comment) { create(:comment) }
      let(:id) { comment.id }

      response '200', 'comment show successfully' do
        run_test!
      end
    end
  end

  path '/comments' do
    post 'Create comments' do
      tags 'Comments'
      produces 'application/json'
      consumes 'application/json'

      parameter name: 'access-token', in: :header, type: :string, description: 'Token'
      parameter name: 'client', in: :header, type: :string, description: 'Client ID'
      parameter name: 'uid', in: :header, type: :string, description: 'User ID'

      let(:task) { create(:task) }
      let(:user) { create(:user) }

      parameter name: :comment, in: :body, schema: {
        type: :object,
        properties: {
          description: { type: :string },
          user_id: { type: :integer },
          task_id: { type: :integer },
          parent_id: { type: :integer },
          replies: { type: :array, items: { type: :object } }
        },
        required: ['description', 'user_id', 'task_id']
      }

      response '201', 'Task comment successfully' do
        let(:comment) {{
          description: 'Descrição',
          user_id: user.id,
          task_id: task.id
        }}

        run_test!
      end

      response '401', 'No token provided' do
        let(:'access-token') { nil }
        let(:client) { nil }
        let(:uid) { nil }
        let(:comment) {}

        run_test!
      end
    end
  end

  path '/comments/{id}' do
    patch 'Update comments' do
      tags 'Comments'
      produces 'application/json'
      consumes 'application/json'

      parameter name: 'access-token', in: :header, type: :string, description: 'Token'
      parameter name: 'client', in: :header, type: :string, description: 'Client ID'
      parameter name: 'uid', in: :header, type: :string, description: 'User ID'
      parameter name: :id, in: :path, type: :string, required: true, description: 'Comment ID'

      let(:user) { create(:user) }
      let(:comment) { create(:comment, description:'Descrição antiga', user_id: user_not_admin.id) }
      let(:id) { comment.id }

      parameter name: :update_comment, in: :body, schema: {
        type: :object,
        properties: {
          description: { type: :string },
          user_id: { type: :integer },
          task_id: { type: :integer },
          parent_id: { type: :integer },
          replies: { type: :array, items: { type: :object } }
        },
        required: ['description']
      }

      response '200', 'Comment successfully updated' do
        let(:update_comment) {{
          description: 'Descrição atualizada'
        }}

        run_test! do |response|
          expect(comment.reload.description).to eq('Descrição atualizada')
        end
      end

      response '401', 'No token provided' do
        let(:'access-token') { nil }
        let(:client) { nil }
        let(:uid) { nil }
        let(:update_comment){}

        run_test! do |response|
          expect(comment.reload.description).to eq('Descrição antiga')
        end
      end

      response '200', 'Comment updated successfully - User admin' do

        let(:user_admin) {create(:user, password: '123456', password_confirmation: '123456', is_admin:true) }
        let(:auth_token) { user_admin.create_new_auth_token }
        let(:'access-token') { auth_token['access-token'] }
        let(:client) { auth_token['client'] }
        let(:uid) { auth_token['uid'] }
        
        let(:update_comment) {{
          description: 'Descrição atualizada'
        }}
  
        run_test! do |response|
          expect(comment.reload.description).to eq('Descrição atualizada')
        end
      end

      response '403', 'Comment update failure - User is not owner or admin' do
        let(:user_nothing) {create(:user, password: '123456', password_confirmation: '123456', is_admin:false) }
        let(:auth_token) { user_nothing.create_new_auth_token }
        let(:'access-token') { auth_token['access-token'] }
        let(:client) { auth_token['client'] }
        let(:uid) { auth_token['uid'] }
        let(:update_comment){}

        run_test! do |response|
          expect(comment.reload.description).to eq('Descrição antiga')
        end 
      end
    end
  end

  path '/comments/{id}' do
    delete 'delete comment' do
      tags 'Comments'
      produces 'application/json'
      consumes 'application/json'
       parameter name: 'access-token', in: :header, type: :string, description: 'Token'
        parameter name: 'client', in: :header, type: :string, description: 'Client ID'
        parameter name: 'uid', in: :header, type: :string, description: 'User ID'
        parameter name: :id, in: :path, type: :string, required: true, description: 'Comment ID'


        let(:comment) { create(:comment, user_id: user_not_admin.id) }
        let(:id) { comment.id }

      response '204', 'Delete comment successfully - User owner' do
      
        run_test! do |response|
          expect(Comment.count).to eq(0)
        end 
      end

      response '401', 'No token provided' do
        let(:'access-token') {nil}
        let(:client) {nil}
        let(:uid) {nil }


        run_test! do |response|
          expect(Comment.count).to eq(1)
        end 
        
      end

      response '204', 'Delete comment successfully - User admin' do
        let(:user) {create(:user, password: '123456', password_confirmation: '123456', is_admin:true) }
        let(:auth_token) { user.create_new_auth_token }
        let(:'access-token') { auth_token['access-token'] }
        let(:client) { auth_token['client'] }
        let(:uid) { auth_token['uid'] }

        run_test! do |response|
          expect(Comment.count).to eq(0)
        end 
      end

      response '403', 'Comment delete failure - User is not owner or admin' do
        let(:user_nothing) {create(:user, password: '123456', password_confirmation: '123456', is_admin:false) }
        let(:auth_token) { user_nothing.create_new_auth_token }
        let(:'access-token') { auth_token['access-token'] }
        let(:client) { auth_token['client'] }
        let(:uid) { auth_token['uid'] }

        run_test! do |response|
          expect(Comment.count).to eq(1)
        end 
      end
    end
  end
end
