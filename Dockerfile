FROM node:lts-alpine

ENV NPM_CONFIG_UPDATE_NOTIFIER=false
RUN apk add --no-cache tini \
    && npm install -g pnpm

ENV NODE_ENV production
WORKDIR /app

COPY --chown=node:node package.json pnpm-lock.yaml ./
# 忽略生命周期脚本，避免执行husky等开发钩子
RUN pnpm install --frozen-lockfile --prod --ignore-scripts

COPY --chown=node:node . .

USER node

EXPOSE 3000

CMD [ "/sbin/tini", "--", "node", "app.js" ]
