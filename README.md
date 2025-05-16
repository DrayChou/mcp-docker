![./assets/tools.png](./assets/tools.png)

# mcp-docker

Docker image for running tools for LLM agents (MCP, OpenAPI, UVX, NPX, Python)

---

## Features

- Python / Node.js runtime (`python`, `node`, `uvx`, `npx`)
- 常用工具：`curl`, `jq`, `git`
- 统一缓存目录 `/app/cache`
- 适合运行各种 MCP 单体服务，轻量灵活

---

## 使用说明

本镜像不再预装 mcpo、supergateway 等服务，适用于灵活拉起 MCP 生态的各种单体服务，例如 [MCP-SuperAssistant Proxy](https://github.com/srbhptl39/MCP-SuperAssistant)。

### 1. 构建 Docker 镜像

在项目根目录下执行：

```bash
docker build -t mcp-base .
```

### 2. 运行 MCP 服务

下面以 MCP SuperAssistant Proxy 为例演示如何使用本镜像运行 MCP 服务。

#### 配置文件示例

MCP服务通常需要一个配置文件，以下是一个适用于MCP-SuperAssistant Proxy的`mcpconfig.json`示例：

```json
{
    "mcpServers": {
        "mcp-server-time": {
            "command": "uvx",
            "args": ["mcp-server-time", "--local-timezone=America/New_York"]
        }
    }
}
```

注意：JSON格式不支持注释，请确保配置文件是有效的JSON。

#### 启动 MCP 服务

##### 方式一：使用配置文件启动

将配置文件放在本地目录，然后挂载到容器中：

**Linux/Mac (bash):**
```bash
docker run --rm -v $(pwd)/mcpconfig.json:/app/mcpconfig.json -p 3006:3006 mcp-base npx @srbhptl39/mcp-superassistant-proxy@latest --config /app/mcpconfig.json
```

**Windows (PowerShell):**
```powershell
docker run --rm -v ${PWD}/mcpconfig.json:/app/mcpconfig.json -p 3006:3006 mcp-base npx @srbhptl39/mcp-superassistant-proxy@latest --config /app/mcpconfig.json
```

**Windows (CMD):**
```cmd
docker run --rm -v %cd%/mcpconfig.json:/app/mcpconfig.json -p 3006:3006 mcp-base npx @srbhptl39/mcp-superassistant-proxy@latest --config /app/mcpconfig.json
```

- `-v ${PWD}/mcpconfig.json:/app/mcpconfig.json` ：将本地配置文件挂载进容器
- `-p 3006:3006` ：暴露默认端口
- `-v cache:/app/cache` ：可选，挂载持久化缓存目录

**重要提示**：确保配置路径一致。如果挂载到 `/app/mcpconfig.json`，那么命令中的 `--config` 参数也应该是 `/app/mcpconfig.json`。

##### 方式二：交互式运行

```bash
docker run -it --rm -v $(pwd)/mcpconfig.json:/app/mcpconfig.json -p 3006:3006 mcp-base bash
# 容器内执行
npx @srbhptl39/mcp-superassistant-proxy@latest --config /app/mcpconfig.json
```

---

### 3. Docker Compose 示例

使用 docker compose 可以更方便地管理服务：

```yaml
services:
  mcp-service:
    image: mcp-base
    command: npx @srbhptl39/mcp-superassistant-proxy@latest --config /app/mcpconfig.json
    ports:
      - 3006:3006
    volumes:
      - ./mcpconfig.json:/app/mcpconfig.json
      - cache:/app/cache
volumes:
  cache:
```

## 运行其他 MCP 服务

本镜像可以运行各种 MCP 生态服务，使用方法类似：

1. 准备对应服务的配置文件
2. 启动容器并挂载配置文件
3. 使用 npx 运行相应的 npm 包

例如运行其他 MCP 服务：

```bash
docker run --rm -v $(pwd)/config.json:/app/config.json -p 3000:3000 mcp-base npx @example/other-mcp-service --config /app/config.json
```

根据实际需求可以调整端口映射、挂载的卷以及运行的命令参数。
