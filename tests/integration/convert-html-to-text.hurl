# tests/integration/convert-html-to-text.hurl
# Authenticated POST to /v1/fragments
POST http://localhost:8080/v1/fragments
# user1@email.com:password1
Authorization: Basic dXNlcjFAZW1haWwuY29tOnBhc3N3b3JkMQ==
# We're sending a html fragment
Content-Type: text/html
# Body of the request goes in ```...``` when it's a string
<h2> Hi </h2>

# We expect to get back an HTTP 201
HTTP/1.1 201
[Captures]
url: header "Location"

# Try to convert that fragment to text
GET {{url}}.txt
Authorization: Basic dXNlcjFAZW1haWwuY29tOnBhc3N3b3JkMQ==

# 200 success response , content-type changed to text/plain
HTTP/1.1 200
[Asserts]
body == ```<h2> Hi </h2>```
