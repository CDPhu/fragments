# tests/integration/delete-fragment.hurl
# Authenticated POST to /v1/fragments
POST http://localhost:8080/v1/fragments
# user1@email.com:password1
Authorization: Basic dXNlcjFAZW1haWwuY29tOnBhc3N3b3JkMQ==
# We're sending a plain text fragment
Content-Type: text/plain
# Body of the request goes in ```...``` when it's a string
```This is a fragment!```

# We expect to get back an HTTP 201
HTTP/1.1 201
[Captures]
url: header "Location"

# DELETE request with authorization
DELETE {{url}} 
Authorization: Basic dXNlcjFAZW1haWwuY29tOnBhc3N3b3JkMQ==

# GOT response 200 successfully DELETE request
HTTP/1.1 200

# Try to get that fragment 
GET {{url}}
Authorization: Basic dXNlcjFAZW1haWwuY29tOnBhc3N3b3JkMQ==

# GET 404 response because no such fragment exists with the given id
HTTP/1.1 404
