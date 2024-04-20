# syntax=docker/dockerfile:1
FROM node:lts-slim@sha256:9f938a1eeb3f85ca7691e1b4b5e9ab91e1d2efa7afc1d3e495b6f8158b7e2d39 as base

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

WORKDIR /app

RUN corepack enable

COPY package.json pnpm-lock.yaml ./

RUN pnpm add -g serve


FROM base as prod-dependencies

RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --prod --frozen-lockfile


FROM base AS build

RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --frozen-lockfile

COPY . .

RUN pnpm run build


FROM chainguard/node-lts@sha256:e8a45ba91e4498c23a49175508f725db87c2e4a1178e3573713f781527dea983 as release

# Non-root user uid=65532(node) is used by default
USER node

WORKDIR /app

# Set node loglevel
ENV NPM_CONFIG_LOGLEVEL warn

COPY --link --chown=65532 --from=prod-dependencies /app/node_modules /app/node_modules
COPY --link --chown=65532 --from=build /app/dist ./dist
COPY --link --chown=65532 --from=build /app/serve.json ./dist
COPY --link --chown=65532 --from=base /pnpm ./pnpm

EXPOSE 3000

ENTRYPOINT [ "/app/pnpm/serve" ]

CMD ["-s", "dist", "-c", "serve.json", "-l", "3000", "-n"]