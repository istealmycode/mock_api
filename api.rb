# frozen_string_literal: true

require 'sinatra'
require 'json'
require 'securerandom'
require 'sinatra/contrib/all'
require_relative 'seeder' # Require the seeder.rb file
require 'faker'

# Data store to hold the JSON blobs
$json_blobs = {}

# Load JSON data at startup
load_json_files

# Endpoint to receive JSON blobs
post '/api/:resource' do
  resource = params[:resource]
  request_body = request.body.read
  begin
    json_data = JSON.parse(request_body)
    # Add a unique ID to the JSON blob
    json_data['id'] = SecureRandom.uuid

    # Initialize an array for the resource if it doesn't exist
    $json_blobs[resource] ||= []

    # Store the JSON blob in the data store
    $json_blobs[resource] << json_data

    json json_data
  rescue JSON::ParserError
    status 400
    json error: 'Invalid JSON data'
  end
end

# Endpoint to retrieve all JSON blobs for a specific resource
get '/api/:resource' do
  resource = params[:resource]
  if $json_blobs.key?(resource)
    json $json_blobs[resource]
  else
    json [] # Return an empty array if the resource doesn't exist
  end
end

# Endpoint to update an existing JSON blob by ID for a specific resource
patch '/api/:resource/:id' do
  resource = params[:resource]
  id = params[:id]

  resource_blobs = $json_blobs[resource]

  if resource_blobs
    requested_blob = resource_blobs.find { |blob| blob['id'] == id }

    if requested_blob
      request_body = request.body.read
      begin
        updated_data = JSON.parse(request_body)
        requested_blob.merge!(updated_data)
        json requested_blob
      rescue JSON::ParserError
        status 400
        json error: 'Invalid JSON data'
      end
    else
      status 404
      json error: "#{resource.capitalize} not found"
    end
  else
    json [] # Return an empty array if the resource doesn't exist
  end
end
