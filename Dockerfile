# 最小化镜像
FROM node:19
WORKDIR /app

# 将 dist 文件夹复制到容器中
COPY ./home/dist ./dist

# 安装 http-server 模块
RUN npm install -g http-server

# 暴露端口
EXPOSE 12445

# 启动 http-server 服务器
CMD ["http-server", "dist", "-p", "12445"]
