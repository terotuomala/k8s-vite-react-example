# syntax=docker/dockerfile:1
FROM node:lts-slim@sha256:309ab4315a7ec2f062a014c6d682f7ae41bd2e87a0aef1620b9cc7dc32139c2c as base

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


FROM chainguard/node@sha256:bc56f4995ea44b2ecd4d9483111dc498b790b00a242712b610ebcbfdf159b87f as release

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