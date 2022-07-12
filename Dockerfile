FROM node:18-slim@sha256:d9fb8f68b97a9d1bd3199b49a8345942d13e392396b5feafb1ad364cca685481 as build

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .

RUN npm run build

RUN npm i -g serve


FROM node:18-slim@sha256:d9fb8f68b97a9d1bd3199b49a8345942d13e392396b5feafb1ad364cca685481 AS release

# Switch to non-root user uid=1000(node)
USER node

WORKDIR /home/node

# Set node loglevel
ENV NPM_CONFIG_LOGLEVEL warn
ENV NODE_OPTIONS --unhandled-rejections=warn

COPY --chown=node:node --from=build /build ./build
COPY --chown=node:node --from=build /serve.json ./build
COPY --chown=node:node --from=build /usr/local/lib/node_modules/serve .npm-global/bin/serve

EXPOSE 3000

CMD ["/home/node/.npm-global/bin/serve/bin/serve.js", "-s", "build", "-c", "serve.json", "-l", "3000", "-n"]
