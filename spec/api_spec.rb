# frozen_string_literal: true

# spec/app_spec.rb
require_relative '../api' # Make sure this path is correct

require 'rack/test'
require 'json'
require 'securerandom'
require 'faker'

RSpec.describe 'Mock API' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  let(:json_headers) { { 'Content-Type' => 'application/json' } }

  before do
    @resource_name = Faker::Internet.unique.domain_word
    post "/api/#{@resource_name}", { name: 'John Doe' }.to_json, json_headers
  end

  describe 'POST /api/:resource' do
    it 'gives ok response on succesful post' do
      expect(last_response).to be_ok
    end

    it 'creates a new JSON blob' do
      blob = JSON.parse(last_response.body)
      expect(blob).to include('id', 'name')
    end

    context 'with invalid json' do
      before do
        post "/api/#{@resource_name}", 'invalid_json', json_headers
      end

      it 'returns a 400 status with invalid JSON' do
        expect(last_response.status).to eq(400)
        error_response = JSON.parse(last_response.body)
        expect(error_response).to include('error')
      end

      it 'returns an error message' do
        error_response = JSON.parse(last_response.body)
        expect(error_response).to include('error')
      end
    end
  end

  describe 'GET /api/:resource' do
    it 'returns all JSON blobs for a specific resource' do
      get "/api/#{@resource_name}"
      expect(last_response).to be_ok
      blobs = JSON.parse(last_response.body)
      expect(blobs).to be_an(Array)
    end

    it 'returns an empty array if the resource does not exist' do
      get '/api/non_existent_resource'
      expect(last_response).to be_ok
      blobs = JSON.parse(last_response.body)
      expect(blobs).to be_empty
    end
  end

  describe 'PATCH /api/:resource/:id' do
    it 'updates an existing JSON blob by ID' do
      blob = JSON.parse(last_response.body)

      patch "/api/#{@resource_name}/#{blob['id']}", { age: 25 }.to_json, json_headers
      expect(last_response).to be_ok
      updated_blob = JSON.parse(last_response.body)

      expect(updated_blob).to include('id', 'name', 'age')
      expect(updated_blob['age']).to eq(25)
    end

    it 'returns a 400 status with invalid JSON' do
      blob = JSON.parse(last_response.body)

      patch "/api/#{@resource_name}/#{blob['id']}", 'invalid_json', json_headers
      expect(last_response.status).to eq(400)
      error_response = JSON.parse(last_response.body)
      expect(error_response).to include('error')
    end

    it 'returns a 404 status when the specific ID does not exist' do
      non_existent_id = SecureRandom.uuid
      patch "/api/#{@resource_name}/#{non_existent_id}", { age: 30 }.to_json, json_headers
      expect(last_response.status).to eq(404)
      error_response = JSON.parse(last_response.body)
      expect(error_response).to include('error')
    end
  end
end
