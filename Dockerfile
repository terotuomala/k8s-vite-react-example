FROM node:18-slim@sha256:f19a9bfe36e66bff93489402385aa4f1024c493ad79fb199eb83ed019f787b47 as build

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .

RUN npm run build

RUN npm i -g serve


FROM node:18-slim@sha256:f19a9bfe36e66bff93489402385aa4f1024c493ad79fb199eb83ed019f787b47 AS release

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

CMD ["/home/node/.npm-global/bin/serve/build/main.js", "-s", "build", "-c", "serve.json", "-l", "3000", "-n"]
