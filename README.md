# rails-marklogic

Minimal MarkLogic REST client for Rails. Drop-in integration for any legacy Rails app.

## Installation

Add to your Gemfile:

```ruby
gem "rails-marklogic"
```

Then run:

```sh
bundle install
rails generate rails_marklogic:install
```

This creates `config/marklogic.yml` and `config/initializers/rails_marklogic.rb`.

## Configuration

Three ways to configure, in priority order:

### 1. Ruby block (highest priority)

```ruby
# config/initializers/rails_marklogic.rb
RailsMarklogic.configure do |config|
  config.host     = "localhost"
  config.port     = 8000
  config.username = "admin"
  config.password = "admin"
end
```

### 2. YAML file

```yaml
# config/marklogic.yml
default: &default
  host: <%= ENV.fetch("MARKLOGIC_HOST", "localhost") %>
  port: <%= ENV.fetch("MARKLOGIC_PORT", 8000) %>
  username: <%= ENV.fetch("MARKLOGIC_USERNAME", "admin") %>
  password: <%= ENV.fetch("MARKLOGIC_PASSWORD", "admin") %>
  auth: digest
  timeout: 30

development:
  <<: *default

production:
  <<: *default
```

### 3. Environment variables (lowest priority)

```sh
export MARKLOGIC_HOST=localhost
export MARKLOGIC_PORT=8000
export MARKLOGIC_USERNAME=admin
export MARKLOGIC_PASSWORD=admin
```

## Usage

### Store documents

```ruby
# JSON (auto-detected)
RailsMarklogic.put_document("/users/1.json", { name: "Eric" }.to_json)

# XML (auto-detected)
RailsMarklogic.put_document("/docs/1.xml", "<doc><title>Hello</title></doc>")

# Binary (explicit content type)
RailsMarklogic.put_document("/files/report.pdf", File.binread("report.pdf"), content_type: "application/pdf")

# With collections
RailsMarklogic.put_document("/users/1.json", data, collections: ["users", "active"])
```

### Retrieve documents

```ruby
body = RailsMarklogic.get_document("/users/1.json")
```

### Delete documents

```ruby
RailsMarklogic.delete_document("/users/1.json")
```

### Execute queries

```ruby
# XQuery
result = RailsMarklogic.eval_xquery('fn:current-dateTime()')
result = RailsMarklogic.eval_xquery('declare variable $x external; $x + 1', variables: { x: "41" })

# JavaScript
result = RailsMarklogic.eval_javascript('fn.currentDateTime()')
```

### Search

```ruby
results = RailsMarklogic.search("keyword")
results = RailsMarklogic.search("test", options: { format: "json", pageLength: "10" })
```

### Direct client access

```ruby
client = RailsMarklogic.client
client.put_document("/doc.json", "{}")
```

## Error handling

```ruby
begin
  RailsMarklogic.get_document("/missing.json")
rescue RailsMarklogic::NotFoundError => e
  puts "Not found: #{e.status}"
rescue RailsMarklogic::AuthenticationError
  puts "Bad credentials"
rescue RailsMarklogic::ServerError => e
  puts "Server error: #{e.body}"
rescue RailsMarklogic::ConnectionError
  puts "Cannot connect to MarkLogic"
rescue RailsMarklogic::Error => e
  puts "Unexpected: #{e.message}"
end
```

## Compatibility

- Ruby >= 2.7
- Rails 5.2 through 8.1+ (also works outside Rails)

## License

MIT
