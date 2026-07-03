FROM node:lts-alpine

# 安装tini
RUN apk add --no-cache tini

# 生产环境
ENV NODE_ENV=production

WORKDIR /app

# 先复制依赖文件，利用docker缓存加速构建
COPY --chown=node:node package*.json yarn.lock* ./

# 安装依赖（优先yarn，没有则用npm）
RUN if [ -f yarn.lock ]; then yarn install --frozen-lockfile --network-timeout=100000; \
    else npm ci; fi

# 再复制源码
COPY --chown=node:node . .

# 切换普通用户运行，安全防权限问题
USER node

EXPOSE 3000

CMD [ "/sbin/tini", "--", "node", "app.js" ]
