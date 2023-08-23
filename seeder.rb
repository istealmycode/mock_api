# frozen_string_literal: true

# seeder.rb
require 'json'

# Function to load JSON data from files and populate $json_blobs
def load_json_files
  Dir.glob('seed_data/*.json').each do |file_path|
    resource_name = File.basename(file_path, '.json')
    json_data = JSON.parse(File.read(file_path))
    $json_blobs[resource_name] = json_data
  end
end
