FROM ghcr.io/astral-sh/uv:debian
RUN apt-get update && apt-get install -y curl jq gnupg git

# Node 环境
RUN curl -sfLS https://install-node.vercel.app/lts | FORCE=true bash

WORKDIR /app
ENV UV_CACHE_DIR=/app/cache/uv
ENV npm_config_cache=/app/cache/npm
ENV npm_config_update_notifier=false

# 这里不再预装/预跑 mcpo、supergateway、inspector 等服务
# 镜像只提供基础环境，方便进入容器后自主 npx/uvx 跑你想跑的 MCP 单个服务
