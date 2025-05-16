![./assets/tools.png](./assets/tools.png)

# mcp-docker

Docker image for running tools for LLM agents (MCP, OpenAPI, UVX, NPX, Python)

## Features

- Python / Node.js runtime (`python`, `node`, `uvx`, `npx`)
- 工具类：`curl`, `jq`, `git`
- 统一的缓存目录 `/app/cache`
- 适合运行各种 MCP 生态单个服务，轻量灵活

## 适用场景

本镜像不再内嵌 mcpo、supergateway 等服务，适用于拉起各种 MCP 单体服务。你可以用 npx/uvx 运行任何符合 MCP 生态的服务。

## 使用方法

### 1. 构建镜像

在本项目目录下执行：

```bash
docker build -t mcp-base .
```

### 2. 运行 MCP 服务（以 MCP-SuperAssistant 为例）

假设你要运行 [MCP-SuperAssistant](https://github.com/srbhptl39/MCP-SuperAssistant)：

#### 方法一：直接运行

```bash
docker run --rm mcp-base npx @srbhptl39/mcp-superassistant
```

#### 方法二：进入容器后手动运行

```bash
docker run -it --rm mcp-base bash
# 在容器内
npx @srbhptl39/mcp-superassistant
```

### 3. 挂载缓存（推荐）

加快 npx/uvx 工具和 node 包缓存速度：

```bash
docker run -v cache:/app/cache mcp-base npx @srbhptl39/mcp-superassistant
```

### 4. docker compose 示例

```yaml
services:
  superassistant:
    image: mcp-base
    command: npx @srbhptl39/mcp-superassistant
    volumes:
      - cache:/app/cache
```

## 自定义你的服务

只需把 `npx 包名` 换成你想运行的 MCP 服务即可。例如：

```bash
docker run --rm mcp-base npx @your-mcp/some-service
```

---

如需将镜像推送到远端仓库（如 Docker Hub），只需将 `mcp-base` 替换为 `yourname/mcp-base`，相关命令一致。

