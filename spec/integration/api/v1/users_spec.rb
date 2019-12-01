require 'swagger_helper'

describe 'Blogs API' do
  path '/users/sign_up' do
    post 'Creates an account' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          firstname: { type: :string },
          lastname: { type: :string },
          email: { type: :string },
          password: { type: :string },
          password_confirmation: { type: :string }
        },
        required: %w[email password password_confirmation]
      }

      response '201', 'User created' do
        let(:user) do
          {
            user: {
              firstname: 'john',
              email: 'john@doe.com',
              password: 'qwerty',
              password_confirmation: 'qwerty'
            }
          }
        end
        run_test!
      end

      response '422', 'Unprocessable Entity' do
        let(:user) { {user: { email: 'foo@dsa.com' }} }
        run_test!
      end
    end
  end

  path '/users/login' do
    post 'Sign in' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: %w[email password]
      }

      response '200', 'User logged in' do
        let(:user) do
          user = create(:user, password: 'qwerty')
          {
            user: {
              email: user.email,
              password: 'qwerty'
            }
          }
        end
        run_test!
      end

      response '401', 'Unauthorized' do
        let(:user) { { email: 'does_not_exist@dsa.com' } }
        run_test!
      end
    end
  end

  path '/users/refresh_token' do
    get 'Refresh jwt token' do
      security [APIKeyHeader: []]
      let(:user) { create(:user) }
      tags 'Users'
      consumes 'application/json'

      response '200', 'New JWT Token' do
        let(:Authorization) { JSONWebToken.encode(user_id: user.id) }
        run_test!
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { JSONWebToken.encode({ user_id: user.id }, 1.day.ago) }
        run_test!
      end
    end
  end

  path '/users/info' do
    get 'Current user informations' do
      security [APIKeyHeader: []]
      let(:user) { create(:user) }
      tags 'Users'
      consumes 'application/json'

      response '200', 'User informations' do
        let(:Authorization) { JSONWebToken.encode(user_id: user.id) }
        run_test!
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { JSONWebToken.encode({ user_id: user.id }, 1.day.ago) }
        run_test!
      end
    end
  end
end
