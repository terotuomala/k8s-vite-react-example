FROM node:16-alpine@sha256:1a9a71ea86aad332aa7740316d4111ee1bd4e890df47d3b5eff3e5bded3b3d10 as build

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .

RUN npm run build

RUN npm i -g serve


FROM node:16-alpine@sha256:1a9a71ea86aad332aa7740316d4111ee1bd4e890df47d3b5eff3e5bded3b3d10 AS release

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
