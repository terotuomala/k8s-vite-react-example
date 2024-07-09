# syntax=docker/dockerfile:1
FROM node:lts-slim@sha256:b5e567dc37677a1485cec21e2f0c0df517c7afe40c1ebc28248c41520c77b3d0 as base

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


FROM chainguard/node-lts@sha256:d6bda943cd8e02b5597d3197b1b652cd0fe5eecafff86208e0946823df00777f as release

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