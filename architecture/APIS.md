# Public APIs

This document defines the public API surface of the platform components.

## marklogic-core (Ruby)

### Client Initialization

```ruby
client = Marklogic::Core::Client.new(
  host: "localhost",
  port: 8000,
  username: "admin",
  password: "admin"
)
```

### Document APIs

```ruby
client.put_document(uri, body, content_type: "application/xml")
client.get_document(uri)
```

### Query Execution

```ruby
client.eval_xquery(xquery, variables: {})
client.eval_javascript(js, variables: {})
```

### Errors
- Non-2xx responses raise Ruby exceptions
- Error body is preserved

## Rails Usage

Rails interacts only with public APIs of `marklogic-core` (and optionally `markmapper`).

## Java / REST

Java and other stacks use the same MarkLogic REST endpoints:
- `/v1/documents`
- `/v1/eval`
- `/v1/search`
- `/manage/v2`

No platform-specific extensions are required.
