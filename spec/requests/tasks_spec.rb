require 'swagger_helper'

RSpec.describe '/Tasks', type: :request do
  let(:user_not_admin) { create(:user, password: '123456', password_confirmation: '123456', is_admin: false) }
  let(:auth_token) { user_not_admin.create_new_auth_token }
  let(:'access-token') { auth_token['access-token'] }
  let(:client) { auth_token['client'] }
  let(:uid) { auth_token['uid'] }
  let(:user_id) { user_not_admin.id }

  path '/tasks' do
    get 'Task list' do
      tags 'Task'
      consumes 'application/json'
      produces 'application/json'

        response '200', 'Task list successfully' do
        run_test!
      end
    end
  end

  path '/tasks/{id}' do
    get 'Show task' do
      tags 'Task'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string, required: true, description: 'Task ID'

      let(:task) { create(:task) }
      let(:id) { task.id }

      response '200', 'Task show successfully' do
        run_test!
      end
    end
  end

  path '/tasks' do
    post 'Create task' do
      tags 'Task'
      produces 'application/json'
      consumes 'application/json'

        parameter name: 'access-token', in: :header, type: :string, description: 'Token'
        parameter name: 'client', in: :header, type: :string, description: 'Client ID'
        parameter name: 'uid', in: :header, type: :string, description: 'User ID'

        parameter name: :task, in: :body, schema: {
          type: :object,
          properties: {
            title: { type: :string },
            description: { type: :string },
            status: { type: :integer },
            estimated_time: { type: :string },
            user_id: { type: :integer }
          },
          required: [ 'title', 'description', 'user_id' ]
        }

        response '201', 'Task created successfully' do
          let(:task) { {
            title: 'Nova tarefa',
            description: 'Descrição da tarefa',
            status: 0,
            user_id: user_not_admin.id
          }}

          run_test!
        end

        response '401', 'No token provided' do
          let(:'access-token') { nil }
          let(:client) { nil }
          let(:uid) { nil }
          let(:task) { }

          run_test!
      end
    end
  end

  path '/tasks/{id}' do
    patch 'Update task' do
      tags 'Task'
      produces 'application/json'
      consumes 'application/json'

      parameter name: 'access-token', in: :header, type: :string, description: 'Token'
      parameter name: 'client', in: :header, type: :string, description: 'Client ID'
      parameter name: 'uid', in: :header, type: :string, description: 'User ID'
      parameter name: :id, in: :path, type: :string, required: true, description: 'Task ID'

      parameter name: :update_task, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          description: { type: :string },
          status: { type: :integer },
          estimated_time: { type: :string },
          user_id: { type: :integer }
        }
      }

      let(:task) { create(:task, title: 'Título antigo', user_id: user_not_admin.id) }
      let(:id) { task.id }

      response '200', 'Task updated successfully - User owner' do
        let(:update_task) { {
          title: 'Nova tarefa',
          description: 'Descrição da tarefa',
          status: 0,
          user_id: user_not_admin.id
        }}

        run_test! do |response|
          expect(task.reload.title).to eq('Nova tarefa')
        end

        response '401', 'No token provided' do
          let(:'access-token') { nil }
          let(:client) { nil }
          let(:uid) { nil }

          run_test! do |response|
            expect(task.reload.title).to eq('Título antigo')
          end
        end

        response '200', 'Task updated successfully - User admin' do
          let(:user_admin) { create(:user, password: '123456', password_confirmation: '123456', is_admin: true) }
          let(:auth_token) { user_admin.create_new_auth_token }
          let(:'access-token') { auth_token['access-token'] }
          let(:client) { auth_token['client'] }
          let(:uid) { auth_token['uid'] }

          let(:update_task) { {
            title: 'Nova tarefa',
            description: 'Descrição da tarefa',
            status: 0,
            user_id: user_not_admin.id
          }}

          run_test! do |response|
            expect(task.reload.title).to eq('Nova tarefa')
          end
        end

        response '403', 'Task update failure - User is not owner or admin' do
          let(:user_nothing) { create(:user, password: '123456', password_confirmation: '123456', is_admin: false) }
          let(:auth_token) { user_nothing.create_new_auth_token }
          let(:'access-token') { auth_token['access-token'] }
          let(:client) { auth_token['client'] }
          let(:uid) { auth_token['uid'] }
          let(:update_task) { }

          run_test! do |response|
            expect(task.reload.title).to eq('Título antigo')
          end
        end
      end
    end
  end

  path '/tasks/{id}' do
    delete 'delete task' do
      tags 'Task'
      produces 'application/json'
      consumes 'application/json'
       parameter name: 'access-token', in: :header, type: :string, description: 'Token'
        parameter name: 'client', in: :header, type: :string, description: 'Client ID'
        parameter name: 'uid', in: :header, type: :string, description: 'User ID'
        parameter name: 'id', in: :path, type: :string, description: 'Task ID'

        let(:task) { create(:task, title: 'Título antigo', user_id: user_not_admin.id) }
        let(:id) { task.id }

      response '204', 'delete task successfully - User owner' do
        run_test! do |response|
          expect(Task.count).to eq(0)
        end
      end

      response '401', 'No token provided' do
        let(:'access-token') { nil }
        let(:client) { nil }
        let(:uid) { nil }


        run_test! do |response|
          expect(Task.count).to eq(1)
        end
      end

      response '204', 'Task delete successfully - User admin' do
        let(:user) { create(:user, password: '123456', password_confirmation: '123456', is_admin: true) }
        let(:auth_token) { user.create_new_auth_token }
        let(:'access-token') { auth_token['access-token'] }
        let(:client) { auth_token['client'] }
        let(:uid) { auth_token['uid'] }

        run_test! do |response|
          expect(Task.count).to eq(0)
        end
      end

      response '403', 'Task delete failure - User is not owner or admin' do
        let(:user_nothing) { create(:user, password: '123456', password_confirmation: '123456', is_admin: false) }
        let(:auth_token) { user_nothing.create_new_auth_token }
        let(:'access-token') { auth_token['access-token'] }
        let(:client) { auth_token['client'] }
        let(:uid) { auth_token['uid'] }

        run_test! do |response|
          expect(Task.count).to eq(1)
        end
      end
    end
  end
end
