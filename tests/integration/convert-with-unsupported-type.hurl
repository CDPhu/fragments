# tests/integration/convert-with-unsupported-type.hurl
# Authenticated POST to /v1/fragments
POST http://localhost:8080/v1/fragments
# user1@email.com:password1
Authorization: Basic dXNlcjFAZW1haWwuY29tOnBhc3N3b3JkMQ==
# We're sending a markdown fragment
Content-Type: text/plain
```hello```

# We expect to get back an HTTP 201
HTTP/1.1 201
[Captures]
url: header "Location"

# Try to convert that fragment to text/markdown
GET {{url}}.md
Authorization: Basic dXNlcjFAZW1haWwuY29tOnBhc3N3b3JkMQ==

# 415 fail response , unsupported conversion
HTTP/1.1 415

# Try to convert that fragment to text/html
GET {{url}}.html
Authorization: Basic dXNlcjFAZW1haWwuY29tOnBhc3N3b3JkMQ==

# 415 fail response , unsupported conversion
HTTP/1.1 415

# Try to convert that fragment to text/plain
GET {{url}}.txt
Authorization: Basic dXNlcjFAZW1haWwuY29tOnBhc3N3b3JkMQ==

# 200 success
HTTP/1.1 200
