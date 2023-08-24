# mock api

Welcome to Mock API! This simple server allows you to perform CRUD operations on various resource names. While the examples use `users`, you can customize them for any resource.

## Getting Started

1. Ensure you have Ruby installed.
2. Start the server using the following command:

```bash
ruby api.rb
```

## Creating a JSON Entry
To add a new JSON entry, use the following curl command:
```bash
curl -X POST -H "Content-Type: application/json" -d '{"name": "John Doe"}' http://localhost:4567/api/users
```

## Retrieving Entries
To retrieve all entries under the specified resource:
```bash
curl http://localhost:4567/api/users
```

To retrieve a specific entry by its ID:
```bash
curl http://localhost:4567/api/users/:id
```

## Updating an Entry
To update an existing entry with a specific ID, use the PATCH method:
```bash
curl -X PATCH -H "Content-Type: application/json" -d '{"age": 30}' http://localhost:4567/api/users/:id
```

## Seeding Data
Pre-populate resources at startup by placing JSON files in the seed_data directory. For example, users.json demonstrates the seeding process.
