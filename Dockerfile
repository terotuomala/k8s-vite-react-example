FROM node:16-alpine@sha256:a2b99f95311def1095e5b9604a81956f4109d9a512a44c86fc382f472cad1d91 as build

RUN apk update && apk add curl bash && rm -rf /var/cache/apk/*

# Install node-prune (https://github.com/tj/node-prune)
RUN curl -sfL https://install.goreleaser.com/github.com/tj/node-prune.sh | bash -s -- -b /usr/local/bin

COPY ["package.json", "package-lock.json*", "./"]

RUN npm ci --production

COPY . .

RUN npm run build

# Run node prune
RUN /usr/local/bin/node-prune

FROM node:16-alpine@sha256:a2b99f95311def1095e5b9604a81956f4109d9a512a44c86fc382f472cad1d91 AS release

# Switch to non-root user uid=1000(node)
USER node

WORKDIR /home/node

# Set global dependencies directory to node user
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global

# Set node loglevel
ENV NPM_CONFIG_LOGLEVEL warn
ENV NODE_OPTIONS --unhandled-rejections=warn

# Install serve to /home/node/.npm-global/bin/serve directory
RUN npm i -g serve

COPY --chown=node:node --from=build /build ./build
COPY --chown=node:node --from=build /serve.json ./build

EXPOSE 3000

CMD ["/home/node/.npm-global/bin/serve", "-s", "build", "-c", "serve.json", "-l", "3000", "-n"]
