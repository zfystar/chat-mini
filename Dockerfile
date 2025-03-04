FROM node:21-alpine as builder
WORKDIR /usr/src
RUN npm install -g pnpm@7
COPY . .
RUN pnpm install
RUN pnpm run build

FROM node:21-alpine
WORKDIR /usr/src
RUN npm install -g pnpm@7
COPY --from=builder /usr/src/dist ./dist
COPY --from=builder /usr/src/hack ./
COPY package.json pnpm-lock.yaml .npmrc ./
RUN pnpm install
ENV HOST=0.0.0.0 PORT=3000 NODE_ENV=production
EXPOSE $PORT
CMD ["/bin/sh", "docker-entrypoint.sh"]
