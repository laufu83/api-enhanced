FROM node:lts-alpine

# 安装 tini + pnpm
RUN apk add --no-cache tini \
    && npm install -g pnpm

ENV NODE_ENV production
WORKDIR /app

# 复制依赖配置
COPY --chown=node:node package.json pnpm-lock.yaml ./

# 生产环境精准安装依赖
RUN pnpm install --frozen-lockfile --prod

# 复制全部源码
COPY --chown=node:node . .

USER node

EXPOSE 3000

CMD [ "/sbin/tini", "--", "node", "app.js" ]
