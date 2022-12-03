# tests/integration/update-fragments-successful.hurl
# Authenticated POST to /v1/fragments
POST http://localhost:8080/v1/fragments
# user1@email.com:password1
Authorization: Basic dXNlcjFAZW1haWwuY29tOnBhc3N3b3JkMQ==
# We're sending a plain text fragment
Content-Type: text/plain
# Body of the request goes in ```...``` when it's a string
```This is a fragment!```


# We expect to get back an HTTP 401
HTTP/1.1 201
[Captures]
url: header "Location"

# PUT request with no authorization
PUT {{url}} 
Authorization: Basic dXNlcjFAZW1haWwuY29tOnBhc3N3b3JkMQ==
Content-Type: text/plain
```line``` 

# GOT response 200 saying update successful
HTTP/1.1 200

# GET the updated fragment data
GET {{url}}
Authorization: Basic dXNlcjFAZW1haWwuY29tOnBhc3N3b3JkMQ==

HTTP/1.1 200
Content-Type: text/plain
```line``` 
