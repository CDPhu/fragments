# Node version
FROM node:16.15.1 AS dependencies

LABEL maintainer="Chan Dinh (Oscar) Phu <cdphu@myseneca.com>"
LABEL description="Fragments node.js microservice"

# We default to use port 8080 in our service
# ENV PORT=8080
ENV NODE_ENV=production​

# Reduce npm spam when installing within Docker
# https://docs.npmjs.com/cli/v8/using-npm/config#loglevel
ENV NPM_CONFIG_LOGLEVEL=warn

# Disable colour when run inside Docker
# https://docs.npmjs.com/cli/v8/using-npm/config#color
ENV NPM_CONFIG_COLOR=false

# Use /app as our working directory
WORKDIR /app

# Copy src to /app/src/
COPY ./src ./src

# Copy the package.json and package-lock.json files into the working dir (/app)
COPY package.json package-lock.json ./

# Install node dependencies defined in package-lock.json
# RUN npm install
RUN npm ci --only=production && \
    npm uninstall sharp && \
    npm install --platform=linuxmusl sharp@0.31.2

# Copy our HTPASSWD file
COPY ./tests/.htpasswd ./tests/.htpasswd

# Start the container by running our server
# CMD npm start
FROM node:16.14.2-alpine3.15@sha256:38bc06c682ae1f89f4c06a5f40f7a07ae438ca437a2a04cf773e66960b2d75bc AS production
# install curl
# RUN apk --no-cache add curl
# RUN apk --no-cache add dumb-init
WORKDIR /
RUN apk --no-cache add curl=7.80.0-r4 && apk --no-cache add dumb-init=1.2.5-r1
COPY --chown=node:node --from=dependencies \
/app/node_modules/ /app/ \
/app/src/ /app/  \
/app/package.json ./

# We default to use port 8080 in our service
ENV PORT=8080
#Sets Healthcheck for our server
HEALTHCHECK --interval=15s \
  CMD curl –-fail http://localhost:${PORT}/ || exit 1​

# Add a user group node
USER node
# Start the container by running our server
CMD ["dumb-init","node","index.js"]
# We run our service on port 8080
EXPOSE 8080
