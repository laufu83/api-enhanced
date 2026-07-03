FROM node:lts-alpine
ENV NPM_CONFIG_UPDATE_NOTIFIER=false
RUN apk add --no-cache tini \
    && npm install -g pnpm

ENV NODE_ENV production
WORKDIR /app

COPY --chown=root:root package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile --prod --ignore-scripts

COPY --chown=root:root . .

USER root
EXPOSE 3000
CMD [ "/sbin/tini", "--", "node", "main.js" ]
