# tests/integration/convert-markdown-to-html.hurl
# Authenticated POST to /v1/fragments
POST http://localhost:8080/v1/fragments
# user1@email.com:password1
Authorization: Basic dXNlcjFAZW1haWwuY29tOnBhc3N3b3JkMQ==
# We're sending a markdown fragment
Content-Type: text/markdown
```## hello```

# We expect to get back an HTTP 201
HTTP/1.1 201
[Captures]
url: header "Location"

# Try to convert that fragment to text
GET {{url}}.html
Authorization: Basic dXNlcjFAZW1haWwuY29tOnBhc3N3b3JkMQ==

# 200 success response , content-type changed to text/html
HTTP/1.1 200
Content-Type: text/html
[Asserts]
body == "<h2>hello</h2>\n"
