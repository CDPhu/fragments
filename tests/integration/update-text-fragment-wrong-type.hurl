# tests/integration/update-fragments-successful.hurl
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

# PUT request with authorization
PUT {{url}} 
Authorization: Basic dXNlcjFAZW1haWwuY29tOnBhc3N3b3JkMQ==
Content-Type: text/markdown
## line

# GOT response 400 meaning can't change content-type once created
HTTP/1.1 400
