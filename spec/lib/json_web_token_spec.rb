require 'rails_helper'

RSpec.describe JSONWebToken do
  let(:payload) { { user_id: 1 } }
  let(:date) { Time.zone.parse('22-10-2019 10:00:00 UTC') }
  let(:october_jwt) { 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1NzE3Mzg0MDB9.ANvl6kxS9b7CH7CGeFI73htKaoBI8Hpw97P2pdpxKaI' }

  describe '.encode' do
    before(:each) do
      @jwt = JSONWebToken.encode(payload, date)
    end

    it { expect(@jwt).to eq(october_jwt) }
    it { expect(@jwt).to_not eq(JSONWebToken.encode(payload, Time.current)) }
  end

  describe '.decode' do
    before(:each) do
      @decoded = JSONWebToken.decode(october_jwt).symbolize_keys
    end

    it { expect(@decoded).to include(payload) }
    it { expect(@decoded).to have_key(:exp) }

    context 'when decoding unvalid jwt' do
      let(:old_date) { 1.year.ago }

      it 'raises exception if jwt is expired' do
        expect do
          token = JSONWebToken.encode(payload, old_date)
          JSONWebToken.decode(token)
        end.to raise_exception(JWT::ExpiredSignature)
      end
    end
  end

  # def self.encode(payload, expire = User::JWT_DURATION.from_now)
  #   payload[:exp] = expire.to_i
  #   JWT.encode(payload, SECRET_KEY)
  # end

  # def self.decode(token)
  #   decoded = JWT.decode(token, SECRET_KEY)[0]
  #   HashWithIndifferentAccess.new(decoded)
  # end
end
