FROM ghcr.io/astral-sh/uv:debian
RUN apt-get update && apt-get install -y curl gnupg git

# From https://github.com/vercel/install-node/
RUN curl -sfLS https://install-node.vercel.app/lts | FORCE=true bash

WORKDIR /app
RUN uvx mcpo --help \
    && npx -y supergateway --help \
    && npx -y @metamcp/mcp-server-metamcp@latest --help