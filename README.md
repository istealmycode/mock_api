# mock_api

You can post, patch or get from any resource name, the examples use `users` but it could be anything

## Start the server
ruby api.rb

## Posting a JSON blob
curl -X POST -H "Content-Type: application/json" -d '{"name": "John Doe"}' http://localhost:4567/api/users

## Retrieving all blobs under the "users" resource
curl http://localhost:4567/api/users

## Retrieving a specific blob by its ID under the "users" resource
curl http://localhost:4567/api/users/:id

## Update an existing blob with ID under the "users" resource
curl -X PATCH -H "Content-Type: application/json" -d '{"age": 30}' http://localhost:4567/api/users/:id

## Seeding at startup
Files in the seed_data directory will make those resources available at startup. See users.json for an example. 
