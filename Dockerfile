FROM node:lts-alpine
ENV NPM_CONFIG_UPDATE_NOTIFIER=false
RUN apk add --no-cache tini \
    && npm install -g pnpm

ENV NODE_ENV production
WORKDIR /app

COPY --chown=node:node package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile --prod --ignore-scripts

COPY --chown=node:node . .

USER node
EXPOSE 3000
# 关键修改：启动 main.js
CMD [ "/sbin/tini", "--", "node", "main.js" ]
