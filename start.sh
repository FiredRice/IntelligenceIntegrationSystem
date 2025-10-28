# 停止容器
docker stop ItIntegrationSystem
# 删除容器
docker rm ItIntegrationSystem
# 删除镜像
docker rmi ItIntegrationSystem:latest

# 构建镜像
docker build --build-arg HTTP_PROXY=http://127.0.0.1:7890 --tag it-integration-system .

# 守护进程运行容器
docker run \
    --restart=unless-stopped \
    -d \
    --privileged=true \
    --name ItIntegrationSystem \
    ItIntegrationSystem

# 打印并交互容器运行记录
docker logs -f ItIntegrationSystem