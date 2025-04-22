require 'rails_helper'
require 'swagger_helper'
require 'stringio'

RSpec.describe "/task_attachments", type: :request do
  let(:user_admin) { create(:user, nickname: 'YYYYYYYYYYYYYYYY', password: '123456', password_confirmation: '123456', is_admin: true) }
  let(:auth_token) { user_admin.create_new_auth_token }
  let(:'access-token') { auth_token['access-token'] }
  let(:client) { auth_token['client'] }
  let(:uid) { auth_token['uid'] }

  let(:task) do
    create(:task).tap do |t|
      t.attachments.attach(
        io: StringIO.new("conteúdo de teste simulando um arquivo"),
        filename: 'teste.txt',
        content_type: 'text/plain'
      )
    end
  end

  let(:task_id) { task.id }
  let(:id) { task.attachments.first.id }

  path '/tasks/{task_id}/attachments/{id}' do
    delete 'Delete attachments task' do
      tags 'Tasks/attachments'
      produces 'application/json'
      consumes 'application/json'

      parameter name: 'access-token', in: :header, type: :string, required: true, description: 'Token'
      parameter name: 'client', in: :header, type: :string, required: true, description: 'Client ID'
      parameter name: 'uid', in: :header, type: :string, required: true, description: 'User ID'
      parameter name: :task_id, in: :path, type: :string, required: true, description: 'Task ID'
      parameter name: :id, in: :path, type: :string, required: true, description: 'Attachment ID'

      response '204', 'Attachment deleted successfully' do
        run_test!
      end

      response '403', 'User Not admin' do
        let(:user_not_owner) { create(:user, email: 'outro@teste.com') }
        let(:auth_token) { user_not_owner.create_new_auth_token }
        let(:'access-token') { auth_token['access-token'] }
        let(:client) { auth_token['client'] }
        let(:uid) { auth_token['uid'] }
      
        let(:owner_user) { create(:user, email: 'dono@123teste.com') }
      
        let(:task) do
          create(:task, user: owner_user).tap do |t|
            t.attachments.attach(
              io: StringIO.new("conteúdo de teste"),
              filename: 'arquivo.txt',
              content_type: 'text/plain'
            )
          end
        end
      
        run_test!
      end

      response '204', 'task proprietor user' do
        let(:user_not_admin) { create(:user, nickname: 'XXXXXXXXXXXXXXX', is_admin: false) }
        let!(:auth_token) { user_not_admin.create_new_auth_token }
        let!(:'access-token') { auth_token['access-token'] }
        let(:client) { auth_token['client'] }
        let(:uid) { auth_token['uid'] }
      
        let(:task) do
          create(:task, user: user_not_admin).tap do |t|
            t.attachments.attach(
              io: StringIO.new("conteúdo de teste"),
              filename: 'arquivo.txt',
              content_type: 'text/plain'
            )
          end
        end   
        run_test!
      end
    end
  end
end