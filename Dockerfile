FROM node:16.17.0-bullseye-slim as builder

WORKDIR /app

COPY . .
RUN npm ci && npm run build

FROM node:16.17.0-bullseye-slim as prod

ENV NODE_ENV production

USER node
WORKDIR /app

COPY --chown=node:node package*.json knexfile.js start.sh ./
RUN npm ci --omit=dev && npm cache clean --force

COPY --chown=node:node migrations ./migrations
COPY --chown=node:node --from=builder /app/build ./build

CMD [ "bash", "start.sh" ]
