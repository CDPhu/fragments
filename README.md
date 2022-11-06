# fragments

CCP555 - this developing project uses Node.js and express module to host an API Server along with AWS Cognito, at this time it takes requests from /GET /POST.

# To Run

`npm i`- installs necessary dependencies for running locally

`npm start` - to start running the server at `node src/index.js`

`npm run lint `- runs check on coding style and problems

When the server started successfully on `localhost:8080` with an health check and the logger message should show that `Server started` and `Cognito JWKS cached`.

# To Test

`npm run dev ` - run the server in development mode
`npm run debug ` - runs the server in debug mode
`nodemon` is configured and will keep monitorning for code changes and restarting the server.

# dependency setups & formatter

`prettier` setup in `.prettierrc`
`eslint` setup in `.eslintrc.js` run `npm run lint` to detect formatting issues.
`Hadolint` used for this project to format the Dockerfile.
Run `Hadolint Dockerfile` to format the Dockerfile.

# Docker image

This project is dockerized, image resides in Dockerhub: [LostButton/fragments](https://hub.docker.com/r/cdoscarphu/fragments/tags)
OR simply run
`docker pull LostButton/fragments:latest`
