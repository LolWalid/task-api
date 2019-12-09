require 'swagger_helper'

describe 'Tasks API' do
  let(:user) { create(:user) }
  let(:Authorization) { JSONWebToken.encode(user_id: user.id) }

  path '/tasks' do
    post 'Creates a Task' do
      security [APIKeyHeader: []]
      tags 'Tasks'
      consumes 'application/json'
      parameter name: :task, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          description: { type: :string }
        },
        required: %w[title]
      }

      response '201', 'Task created' do
        let(:task) do
          {
            task: {
              title: 'Put the table',
              description: 'Put the table before noon!'
            }
          }
        end
        run_test!
      end

      response '422', 'Unprocessable Entity' do
        let(:task) { { task: { title: nil } } }
        run_test!
      end
    end
  end

  path '/tasks/{id}' do
    delete 'Delete a Task' do
      security [APIKeyHeader: []]
      tags 'Tasks'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string

      response '204', 'Task deleted' do
        let(:task) { create(:task, user: user) }
        let(:id) { task.token }

        run_test!
      end
    end
  end

  path '/tasks' do
    get 'Task List' do
      security [APIKeyHeader: []]
      tags 'Tasks'
      consumes 'application/json'
      parameter name: :page, in: :query, type: :integer
      parameter name: :per_page, in: :query, type: :integer

      let(:page) { 1 }
      let(:per_page) { 1 }

      response '200', 'List' do
        let(:task) { create(:task, user: user) }

        run_test!
      end
    end
  end

  path '/tasks/{id}' do
    patch 'update a Task' do
      security [APIKeyHeader: []]
      tags 'Tasks'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :task, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          description: { type: :string }
        },
        required: %w[title]
      }

      response '200', 'Task updated' do
        let(:id) { create(:task, user: user).token }

        let(:task) do
          {
            task: {
              title: 'Put the table',
              description: 'Put the table before noon!'
            }
          }
        end
        run_test!
      end

      response '422', 'Unprocessable Entity' do
        let(:task) { { task: { title: nil } } }
        let(:id) { create(:task, user: user).token }
        run_test!
      end
    end
  end

  path '/tasks/{id}/mark_as_done' do
    put 'mark as done' do
      security [APIKeyHeader: []]
      tags 'Tasks'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'Task done!' do
        let(:id) { create(:task, user: user).token }
        run_test!
      end
    end
  end
end
