# Chutney Server

This is a very simple, Roda-based server that accepts JSON formatted POST requests containing a `gherkin` key with a string value. It will pass this to a Chutney linting service and return the results.

Most of the default linting rules are enabled but the filename checking linters are disabled. This is because the filename is not known to the server and is not passed to the linter.

## Running the server

You will need to have a Ruby 3.3.x environement.

### In a Ruby environment

Clone the repository and run `bundle install` to install the dependencies. Then run `bundle exec puma` to start the server.

### In a Docker environment

Clone the repository and run `docker build -t chutney-server .` to build the Docker image. Then run `docker run -p 9292:9292 chutney-server` to start the server.

## Using the server

The server listens on port 9292. You can send a POST request to the `/lint` endpoint with a JSON body containing a `gherkin` key and a string value. The server will return a JSON response with the linting results.

### Example

```bash
curl -XPOST -H "Content-type: application/json" -d '{"gherkin":"Feature: hello world\nScenario: Posting Gherkin\nWhen I post a Gherkin document\nThen I get an opinion"}' 'http://localhost:9292/lint'

# Returns something like:
# [{"linter":"MissingFeatureDescription","issues":[{"message":"Features should have a description / value statement so that the importance of the feature is well understood.","gherkin_type":"feature","location":{"line":1,"column":1},"feature":"hello world","scenario":null,"step":null}]}]
```
