# syntax=docker/dockerfile:1
FROM node:lts-slim@sha256:b2fa526a10dad3c5ab4b3779eca81607ed05a96160ef5497c36cd4ebed68803d as base

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


FROM chainguard/node@sha256:a2d0d24f74638473f2b92410a5199e1874f17ce12fab3c2d24b737340330456a as release

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