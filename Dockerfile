# 最小化镜像
FROM node:19
WORKDIR /app
COPY ./dist ./dist
RUN npm install -g http-server

EXPOSE 12445
CMD ["http-server", "dist", "-p", "12445"]
