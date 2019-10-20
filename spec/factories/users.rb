FactoryBot.define do
  factory :user do
    email { 'user@email.com' }
    firstname { email.split('@').first }
    lastname { email.split('@').second }
    password { 'valid_password' }
  end
end
