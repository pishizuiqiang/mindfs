# MindFS 与 Claude Code 集成配置问答文档

## 目录
1. [API Key 配置](#q1-mindfs-连接-claude-code-时是否可以指定-api-key)
2. [第三方模型支持](#q2-claude-code-是否支持配置第三方模型比如-glm-51)
3. [配置方法对比](#q3-方法一和方法二有什么区别)
4. [Backend 概念解释](#q4-backend-是什么意思)
5. [多 Agent 配置实战](#q5-如何同时配置多个第三方-agent)
6. [配置文件优先级](#q6-mindfs-配置文件的优先级是怎样的)
7. [重启和管理](#q7-如何便捷地重启-mindfs)

---

## Q1: MindFS 连接 Claude Code 时是否可以指定 API key?

**答：** 是的，MindFS 完全支持在连接 Claude Code 时指定 API key，通过在 `agents.json` 配置文件中设置环境变量来实现。

### 配置文件位置

- **用户配置**：`~/.config/mindfs/agents.json`
- **项目配置**：`<your-project>/.mindfs/agents.json`

### 配置方法

在 `agents.json` 中为 Claude agent 添加 `env` 字段：

```json
{
  "agents": [
    {
      "name": "claude",
      "command": "claude",
      "protocol": "claude-sdk",
      "env": {
        "ANTHROPIC_API_KEY": "your-api-key-here"
      }
    }
  ]
}
```

### 支持的环境变量

- `ANTHROPIC_API_KEY` - Claude Code 使用的标准 API key
- `ANTHROPIC_BASE_URL` - 自定义 API endpoint（可选）
- 其他自定义环境变量

### 技术原理

MindFS 在启动 Claude Code 会话时，会自动将 `env` 字段中配置的环境变量传递给底层的 Claude SDK，通过 `claudeagent.WithEnv(opts.Env)` 实现。

---

## Q2: Claude Code 是否支持配置第三方模型，比如 GLM 5.1?

**答：** 是的，完全支持。Claude Code 可以通过环境变量切换到第三方 API，包括智谱 GLM 等兼容 Anthropic API 格式的服务。

### 支持证据

从当前环境配置可以看到：
```bash
ANTHROPIC_BASE_URL=https://open.bigmodel.cn/api/anthropic
ANTHROPIC_AUTH_TOKEN=62d4531d3cf74db0b3c8764ad7a4f86d.5lohk8um0tdydGYF
```

这证明了 Claude Code 确实可以通过环境变量使用第三方 API。

### 配置第三方模型的步骤

#### 步骤 1：确定第三方 API 信息
- API endpoint（如：`https://open.bigmodel.cn/api/anthropic`）
- API key 或 token
- 支持的模型名称

#### 步骤 2：在 agents.json 中配置

```json
{
  "agents": [
    {
      "name": "claude-glm",
      "command": "claude",
      "protocol": "claude-sdk",
      "env": {
        "ANTHROPIC_BASE_URL": "https://open.bigmodel.cn/api/anthropic",
        "ANTHROPIC_API_KEY": "your-glm-api-key",
        "ANTHROPIC_MODEL": "glm-4-plus"
      }
    }
  ]
}
```

#### 步骤 3：验证配置
1. 重启 MindFS
2. 检查 Agent 状态
3. 创建新会话测试

### 常用环境变量

```bash
# API endpoint
ANTHROPIC_BASE_URL=https://open.bigmodel.cn/api/anthropic

# 认证信息（二选一）
ANTHROPIC_API_KEY=your-api-key
ANTHROPIC_AUTH_TOKEN=your-token

# 模型选择（可选）
ANTHROPIC_MODEL=glm-4-plus
```

### GLM 支持的模型（示例）

- `glm-4-plus`
- `glm-4-0520`
- `glm-4-air`
- `glm-4-flash`

### 前提条件

1. **API 兼容性**：第三方服务需要提供兼容 Anthropic API 的接口
2. **网络访问**：能够访问第三方 API 的网络地址
3. **有效凭证**：拥有有效的 API key 或 token

---

## Q3: 方法一和方法二有什么区别?

**答：** 两种方法的本质区别在于：**方法一创建新的独立 Agent，方法二修改现有 Agent**。这影响到在 MindFS 中的使用体验和灵活性。

### 方法一：创建新的独立 Agent

```json
{
  "agents": [
    {
      "name": "claude-glm",
      "command": "claude",
      "protocol": "claude-sdk",
      "env": {
        "ANTHROPIC_BASE_URL": "https://open.bigmodel.cn/api/anthropic",
        "ANTHROPIC_API_KEY": "your-glm-api-key",
        "ANTHROPIC_MODEL": "glm-4-plus"
      }
    }
  ]
}
```

**特点：**
- ✅ 创建名为 "claude-glm" 的新 agent
- ✅ 原有的 "claude" agent 仍然存在
- ✅ 可以在多个 backend 之间灵活切换
- ✅ 适合 A/B 测试和渐进式迁移

**MindFS UI 显示：**
```
Agent 选择器:
├── claude (官方 Anthropic)
└── claude-glm (智谱 GLM)
```

### 方法二：修改现有 Agent

```json
{
  "agents": [
    {
      "name": "claude",
      "command": "claude",
      "protocol": "claude-sdk",
      "env": {
        "ANTHROPIC_BASE_URL": "https://open.bigmodel.cn/api/anthropic",
        "ANTHROPIC_AUTH_TOKEN": "your-token-here"
      }
    }
  ]
}
```

**特点：**
- ✅ 替换原有的 "claude" agent
- ✅ 配置简洁，只维护一个 agent
- ✅ 所有使用 "claude" 的地方自动切换到新 backend
- ✅ 适合确定只使用第三方 API 的情况

**MindFS UI 显示：**
```
Agent 选择器:
└── claude (实际上是 GLM backend)
```

### 方法一完整配置示例（推荐用于测试）

```json
{
  "agents": [
    {
      "name": "claude",
      "command": "claude",
      "protocol": "claude-sdk"
    },
    {
      "name": "claude-glm",
      "command": "claude",
      "protocol": "claude-sdk",
      "env": {
        "ANTHROPIC_BASE_URL": "https://open.bigmodel.cn/api/anthropic",
        "ANTHROPIC_API_KEY": "glm-key"
      }
    }
  ]
}
```

### 适用场景对比

| 场景 | 推荐方法 | 原因 |
|------|----------|------|
| 测试第三方 API | 方法一 | 保留原有选择，可随时切换回原服务 |
| 确定只使用第三方 API | 方法二 | 简化配置，减少维护成本 |
| 需要多 provider 对比 | 方法一 | 可同时配置多个 agent 进行对比 |
| 逐步迁移验证 | 方法一 | 可以并行使用，逐步验证稳定性 |
| 生产环境单一 backend | 方法二 | 配置简单，性能最优 |

### 环境变量差异

**方法一使用：**
- `ANTHROPIC_API_KEY` - 标准 API key 格式
- `ANTHROPIC_MODEL` - 明确指定模型

**方法二使用：**
- `ANTHROPIC_AUTH_TOKEN` - Token 格式认证
- 不指定具体模型，使用默认配置

---

## Q4: Backend 是什么意思?

**答：** 在 MindFS 上下文中，**Backend（后端）指的是 Agent 实际连接的 AI 服务提供者**。

### 形象的比喻

**MindFS 就像一个万能遥控器：**
```
你操作 MindFS（遥控器）
         ↓
   选择 Agent（按键）
         ↓
连接到 Backend（实际的电视品牌）
```

### 技术架构

```
┌─────────────────┐
│   MindFS UI     │ ← 前端界面
└────────┬────────┘
         │
┌────────▼────────┐
│ Claude Code     │ ← 中间适配层
│  Protocol       │
└────────┬────────┘
         │
┌────────▼────────┐
│  AI Provider    │ ← Backend（后端服务）
│  - Anthropic    │
│  - 智谱 GLM     │
│  - 其他 provider│
└─────────────────┘
```

### Backend 决定的因素

| 因素 | 说明 |
|------|------|
| 🌐 **服务提供商** | Anthropic、智谱、阿里云等 |
| 💰 **计费方式** | 不同 provider 的收费标准和方式 |
| 🤖 **可用模型** | 每个 provider 支持的模型列表不同 |
| ⚡ **响应速度** | 不同服务器的响应延迟差异 |
| 🔒 **数据隐私** | 数据实际发送到哪个服务商 |
| 🌍 **网络位置** | 服务器地理位置影响访问速度 |

### 实际例子对比

#### 相同 Agent，不同 Backend

**Backend A: 官方 Anthropic**
```json
{
  "name": "claude",
  "env": {
    "ANTHROPIC_API_KEY": "sk-ant-xxx"
  }
}
```
- Backend: **Anthropic 官方服务器**
- 模型: Claude-3.5-Sonnet 等
- 计费: 按 Anthropic 价格表

**Backend B: 智谱 GLM**
```json
{
  "name": "claude",
  "env": {
    "ANTHROPIC_BASE_URL": "https://open.bigmodel.cn/api/anthropic",
    "ANTHROPIC_AUTH_TOKEN": "glm-token"
  }
}
```
- Backend: **智谱 GLM 服务器**
- 模型: GLM-4-Plus 等
- 计费: 按智谱价格表

### MindFS 的优势

无论选择哪个 Backend，**MindFS 的使用体验完全一致**：
- ✅ 操作界面相同
- ✅ 功能特性相同
- ✅ 无需学习新的操作方式
- ✅ 可以随时切换 Backend

### 为什么叫 Backend？

从软件架构角度：
- **Frontend（前端）** = 用户界面
- **Backend（后端）** = 实际处理数据的服务

在 MindFS 场景中：
- **Frontend** = MindFS 的 Web 界面
- **Backend** = 真正提供 AI 服务的服务器

### 实际影响示例

**使用场景：代码生成任务**

```
MindFS 界面操作（相同）
         ↓
选择 "claude" agent（相同）
         ↓
┌────────┴────────┐
│  选择 Backend   │
├────────┬────────┤
│Anthropic│ GLM   │  ← Backend 不同
└────────┴────────┘
         ↓
   不同的结果：
   - 响应速度
   - 代码质量
   - 成本费用
   - 数据隐私
```

---

## Q5: 如何同时配置多个第三方 Agent?

**答：** 可以通过创建多个独立的 agent 配置来实现同时使用多个第三方服务，关键是采用统一的命名规则和正确的环境变量配置。

### 实战案例：配置多个第三方 Agents

以下是一个实际的多 agent 配置案例，包含 DeepSeek、MiMo、智谱 GLM 等多个服务：

```json
{
  "agents": [
    // 保留原有官方 claude
    {
      "name": "claude",
      "command": "claude",
      "protocol": "claude-sdk"
    },
    
    // DeepSeek V4 Flash (快速响应)
    {
      "name": "claude-deepseek-flash",
      "command": "claude",
      "protocol": "claude-sdk",
      "env": {
        "ANTHROPIC_API_KEY": "sk-74c6d3beeb754b38ade717217a40b9a2",
        "ANTHROPIC_BASE_URL": "https://api.deepseek.com/anthropic",
        "ANTHROPIC_MODEL": "deepseek-v4-flash"
      }
    },
    
    // DeepSeek V4 Pro (高质量)
    {
      "name": "claude-deepseek-pro",
      "command": "claude",
      "protocol": "claude-sdk",
      "env": {
        "ANTHROPIC_API_KEY": "sk-74c6d3beeb754b38ade717217a40b9a2",
        "ANTHROPIC_BASE_URL": "https://api.deepseek.com/anthropic",
        "ANTHROPIC_MODEL": "deepseek-v4-pro"
      }
    },
    
    // MiMo V2.5 Pro
    {
      "name": "claude-mimo-pro",
      "command": "claude",
      "protocol": "claude-sdk",
      "env": {
        "ANTHROPIC_API_KEY": "tp-c823w3ub9bbd6hrrmvnwlw6glyxaehsrn387cnmr4ce73271",
        "ANTHROPIC_BASE_URL": "https://token-plan-cn.xiaomimimo.com/anthropic",
        "ANTHROPIC_MODEL": "mimo-v2.5-pro"
      }
    },
    
    // 智谱 GLM 5.1
    {
      "name": "claude-glm-5.1",
      "command": "claude",
      "protocol": "claude-sdk",
      "env": {
        "ANTHROPIC_AUTH_TOKEN": "62d4531d3cf74db0b3c8764ad7a4f86d.5lohk8um0tdydGYF",
        "ANTHROPIC_BASE_URL": "https://open.bigmodel.cn/api/anthropic",
        "ANTHROPIC_MODEL": "glm-5.1"
      }
    }
  ]
}
```

### 命名规则建议

#### 推荐的命名格式：`claude-<服务商>-<模型特性>`

**优点：**
- ✅ 明确表示基于 Claude Code
- ✅ 清晰标识服务商和模型
- ✅ 便于分组和搜索
- ✅ 扩展性好

**示例：**
- `claude-deepseek-flash` - Claude Code + DeepSeek + Flash版本
- `claude-glm-5.1` - Claude Code + 智谱 + 5.1版本
- `claude-mimo-pro` - Claude Code + MiMo + Pro版本

#### 其他命名方案

**简化版：**
- `claude-ds-flash`, `claude-ds-pro`, `claude-zhipu`

**功能导向版：**
- `claude-fast`, `claude-quality`, `claude-chinese`

### 任务类型匹配策略

配置完成后，可以根据任务特性选择不同的 agents：

| Agent 名称 | 适用场景 | 特点 |
|------------|----------|------|
| `claude-deepseek-flash` | 日常快速任务、简单查询 | 响应快速，成本较低 |
| `claude-deepseek-pro` | 复杂推理、深度分析 | 输出质量高 |
| `claude-mimo-pro` | 成本敏感项目 | 成本优化 |
| `claude-glm-5.1` | 中文内容生成 | 中文优化 |
| `claude` | 标准任务 | 官方 Anthropic |

### 认证方式说明

不同服务商可能使用不同的认证格式：

#### API Key 格式（常见）
```json
"env": {
  "ANTHROPIC_API_KEY": "sk-xxxxx",
  "ANTHROPIC_BASE_URL": "https://api.example.com/anthropic"
}
```

#### Token 格式（智谱等）
```json
"env": {
  "ANTHROPIC_AUTH_TOKEN": "your-token-here",
  "ANTHROPIC_BASE_URL": "https://open.bigmodel.cn/api/anthropic"
}
```

### API Key 共享

同一服务商的多个模型可以共享同一个 API key：

```json
{
  "name": "claude-deepseek-flash",
  "env": {
    "ANTHROPIC_API_KEY": "sk-shared-key-123"  // 相同的 key
  },
  // ...
},
{
  "name": "claude-deepseek-pro", 
  "env": {
    "ANTHROPIC_API_KEY": "sk-shared-key-123"  // 共享 key
  },
  // ...
}
```

### 配置验证

配置完成后，在 MindFS UI 中应该看到：

```
Agent 选择器:
├── claude                 (官方 Anthropic)
├── claude-deepseek-flash  (DeepSeek V4 Flash)
├── claude-deepseek-pro    (DeepSeek V4 Pro)
├── claude-mimo-pro        (MiMo V2.5 Pro)
└── claude-glm-5.1         (智谱 GLM 5.1)
```

### 常见问题

**Q: 为什么有些 Agent 显示 unavailable？**
- 检查网络连接
- 验证 API key 有效性
- 确认 endpoint URL 正确

**Q: 可以配置多少个 Agent？**
- 理论上无限制，建议 5-10 个以便于管理

**Q: 如何测试新配置的 Agent？**
- 创建新会话
- 发送简单测试消息
- 检查响应速度和质量

---

## Q6: MindFS 配置文件的优先级是怎样的?

**答：** MindFS 按照特定的优先级顺序查找配置文件，了解这个顺序很重要，否则可能会修改错误的文件。

### 配置文件优先级

MindFS 按以下顺序查找 `agents.json` 配置文件：

#### 1. 用户配置目录（最高优先级）
```bash
~/.config/mindfs/agents.json
```
- **推荐位置**：这是用户级别的配置
- **优先级最高**：如果存在，优先使用此文件
- **适用场景**：用户自定义配置

#### 2. 安装目录配置
```bash
~/.local/share/mindfs/agents.json
```
- **默认位置**：MindFS 安装时的配置目录
- **优先级次之**：当用户配置不存在时使用
- **注意**：实际测试发现此位置可能不被读取

#### 3. 项目配置目录
```bash
<project>/.mindfs/agents.json
```
- **项目级别**：特定项目的配置
- **优先级较低**：用于项目特定的 agent 覆盖

#### 4. 内置默认配置（最低优先级）
- MindFS 代码中硬编码的默认配置
- 当前没有任何配置文件时使用

### 实际验证经验

通过实际测试发现：

```bash
# 修改这个文件不会生效
~/.local/share/mindfs/agents.json

# 正确的配置文件位置
~/.config/mindfs/agents.json
```

### 配置文件管理建议

#### 推荐的配置策略

**1. 使用用户配置目录**
```bash
# 创建配置目录（如果不存在）
mkdir -p ~/.config/mindfs

# 编辑配置文件
nano ~/.config/mindfs/agents.json
```

**2. 设置适当的文件权限**
```bash
# 保护敏感的 API keys
chmod 600 ~/.config/mindfs/agents.json
```

**3. 创建配置备份**
```bash
# 备份当前配置
cp ~/.config/mindfs/agents.json ~/.config/mindfs/agents.json.backup
```

### 配置文件诊断

#### 检查当前使用的配置文件

```bash
# 方法 1：查看 MindFS 日志
tail -f ~/.local/share/mindfs/logs/mindfs.log | grep -i config

# 方法 2：检查文件存在性
ls -la ~/.config/mindfs/agents.json
ls -la ~/.local/share/mindfs/agents.json

# 方法 3：通过 API 验证
curl http://localhost:7331/api/agents
```

#### 确定配置文件位置

```bash
# 查找所有 agents.json 文件
find ~ -name "agents.json" -path "*/mindfs/*" 2>/dev/null

# 检查配置目录结构
tree ~/.config/mindfs/
tree ~/.local/share/mindfs/
```

### 常见配置陷阱

#### 陷阱 1：修改了错误的配置文件

**问题：**
```bash
# 修改了这个文件，但不生效
~/.local/share/mindfs/agents.json
```

**解决：**
```bash
# 应该修改用户配置目录
~/.config/mindfs/agents.json
```

#### 陷阱 2：配置目录不存在

**问题：**
```bash
# 配置目录不存在，使用内置配置
ls: ~/.config/mindfs/agents.json: No such file or directory
```

**解决：**
```bash
# 创建配置目录和文件
mkdir -p ~/.config/mindfs
cat > ~/.config/mindfs/agents.json << 'EOF'
{
  "agents": []
}
EOF
```

#### 陷阱 3：项目配置覆盖

**问题：**
项目配置 `.mindfs/agents.json` 可能覆盖用户配置

**解决：**
了解优先级，必要时删除项目配置

### 配置迁移指南

#### 从旧配置迁移到新位置

```bash
# 1. 备份现有配置
cp ~/.local/share/mindfs/agents.json ~/.local/share/mindfs/agents.json.old

# 2. 创建用户配置目录
mkdir -p ~/.config/mindfs

# 3. 复制配置到正确位置
cp ~/.local/share/mindfs/agents.json ~/.config/mindfs/agents.json

# 4. 重启 MindFS
restart-mindfs

# 5. 验证配置生效
curl http://localhost:7331/api/agents
```

---

## Q7: 如何便捷地重启 MindFS?

**答：** 可以通过创建重启脚本或系统服务来实现便捷的 MindFS 重启管理。

### 方法 1：一键重启命令

#### 简单版
```bash
kill $(ps aux | grep "[m]indfs" | awk '{print $2}') 2>/dev/null; sleep 2; cd /home/pishi/coding/mindfs && nohup ./mindfs -addr 0.0.0.0:7331 /home/pishi/coding/mindfs > /dev/null 2>&1 & sleep 3 && ps aux | grep "[m]indfs"
```

#### 带状态输出版
```bash
echo "🔄 重启 MindFS..." && kill $(ps aux | grep "[m]indfs" | awk '{print $2}') 2>/dev/null && sleep 2 && cd /home/pishi/coding/mindfs && nohup ./mindfs -addr 0.0.0.0:7331 /home/pishi/coding/mindfs > /dev/null 2>&1 & sleep 3 && echo "✅ MindFS 已重启，新进程 PID: $(ps aux | grep "[m]indfs" | awk '{print $2}')"
```

### 方法 2：创建重启脚本（推荐）

#### 脚本内容
```bash
#!/bin/bash
echo "🔄 重启 MindFS..."

# 杀掉现有进程
MINDFS_PID=$(ps aux | grep "[m]indfs" | awk '{print $2}')
if [ -n "$MINDFS_PID" ]; then
    echo "停止旧进程 (PID: $MINDFS_PID)"
    kill $MINDFS_PID 2>/dev/null
    sleep 2
fi

# 启动新进程
cd /home/pishi/coding/mindfs
echo "启动新 MindFS..."
nohup ./mindfs -addr 0.0.0.0:7331 /home/pishi/coding/mindfs > /dev/null 2>&1 &

# 等待启动
sleep 3

# 验证新进程
NEW_PID=$(ps aux | grep "[m]indfs" | awk '{print $2}')
if [ -n "$NEW_PID" ]; then
    echo "✅ MindFS 已成功重启，新进程 PID: $NEW_PID"
    echo "🌐 访问地址: http://127.0.0.1:7331?root=mindfs"
    echo "📋 日志文件: /root/.local/share/mindfs/logs/mindfs.log"
else
    echo "❌ MindFS 启动失败，请检查日志"
    tail -20 /root/.local/share/mindfs/logs/mindfs.log
fi
```

#### 安装脚本
```bash
# 1. 创建脚本文件
cat > /home/pishi/coding/mindfs/restart-mindfs.sh << 'EOF'
#!/bin/bash
echo "🔄 重启 MindFS..."

MINDFS_PID=$(ps aux | grep "[m]indfs" | awk '{print $2}')
if [ -n "$MINDFS_PID" ]; then
    echo "停止旧进程 (PID: $MINDFS_PID)"
    kill $MINDFS_PID 2>/dev/null
    sleep 2
fi

cd /home/pishi/coding/mindfs
echo "启动新 MindFS..."
nohup ./mindfs -addr 0.0.0.0:7331 /home/pishi/coding/mindfs > /dev/null 2>&1 &

sleep 3

NEW_PID=$(ps aux | grep "[m]indfs" | awk '{print $2}')
if [ -n "$NEW_PID" ]; then
    echo "✅ MindFS 已成功重启，新进程 PID: $NEW_PID"
    echo "🌐 访问地址: http://127.0.0.1:7331?root=mindfs"
    echo "📋 日志文件: /root/.local/share/mindfs/logs/mindfs.log"
else
    echo "❌ MindFS 启动失败，请检查日志"
    tail -20 /root/.local/share/mindfs/logs/mindfs.log
fi
EOF

# 2. 添加执行权限
chmod +x /home/pishi/coding/mindfs/restart-mindfs.sh

# 3. 创建快捷命令
echo 'alias restart-mindfs="/home/pishi/coding/mindfs/restart-mindfs.sh"' >> ~/.bashrc
source ~/.bashrc
```

#### 使用脚本
```bash
# 直接运行
/home/pishi/coding/mindfs/restart-mindfs.sh

# 或使用快捷命令
restart-mindfs
```

### 方法 3：系统级重启脚本

#### 安装到系统 PATH
```bash
# 创建系统级脚本
sudo cat > /usr/local/bin/restart-mindfs << 'EOF'
#!/bin/bash
echo "🔄 重启 MindFS..."
MINDFS_PID=$(ps aux | grep "[m]indfs" | awk '{print $2}')
if [ -n "$MINDFS_PID" ]; then
    echo "停止旧进程 (PID: $MINDFS_PID)"
    kill $MINDFS_PID 2>/dev/null
    sleep 2
fi
cd /home/pishi/coding/mindfs
echo "启动新 MindFS..."
nohup ./mindfs -addr 0.0.0.0:7331 /home/pishi/coding/mindfs > /dev/null 2>&1 &
sleep 3
NEW_PID=$(ps aux | grep "[m]indfs" | awk '{print $2}')
if [ -n "$NEW_PID" ]; then
    echo "✅ MindFS 已成功重启，新进程 PID: $NEW_PID"
    echo "🌐 访问地址: http://127.0.0.1:7331?root=mindfs"
else
    echo "❌ MindFS 启动失败"
fi
EOF

# 添加执行权限
sudo chmod +x /usr/local/bin/restart-mindfs
```

#### 使用系统级命令
```bash
# 任何地方都可以直接运行
restart-mindfs
```

### 重启验证

#### 检查进程状态
```bash
# 查看进程信息
ps aux | grep mindfs | grep -v grep

# 查看网络监听
netstat -tlnp | grep 7331

# 查看 MindFS 日志
tail -f /root/.local/share/mindfs/logs/mindfs.log
```

#### API 验证
```bash
# 检查 agents 接口
curl http://localhost:7331/api/agents

# 检查服务状态
curl http://localhost:7331/api/status
```

### 常见重启问题

#### 问题 1：进程未完全停止
```bash
# 强制杀掉所有 MindFS 进程
pkill -9 mindfs

# 等待几秒后重新启动
sleep 3
cd /home/pishi/coding/mindfs && ./mindfs -addr 0.0.0.0:7331 /home/pishi/coding/mindfs &
```

#### 问题 2：端口被占用
```bash
# 查看端口占用
lsof -i :7331

# 杀掉占用端口的进程
kill -9 <PID>
```

#### 问题 3：配置未生效
```bash
# 确认修改了正确的配置文件
# 应该是 ~/.config/mindfs/agents.json

# 重启后验证
curl http://localhost:7331/api/agents
```

### 自动化建议

#### 配置修改后自动重启
```bash
# 创建监控脚本
cat > /home/pishi/coding/mindfs/watch-config.sh << 'EOF'
#!/bin/bash
CONFIG_FILE="$HOME/.config/mindfs/agents.json"
while true; do
    inotifywait -e modify "$CONFIG_FILE" 2>/dev/null
    echo "配置文件已修改，自动重启 MindFS..."
    restart-mindfs
    sleep 5
done
EOF

chmod +x /home/pishi/coding/mindfs/watch-config.sh
```

---

## 附录：快速参考

### 配置文件路径（按优先级排序）
1. **用户级配置**（最高优先级）：`~/.config/mindfs/agents.json`
2. **安装级配置**：`~/.local/share/mindfs/agents.json`
3. **项目级配置**：`<project>/.mindfs/agents.json`
4. **内置默认配置**：代码中的硬编码配置

**推荐使用**：`~/.config/mindfs/agents.json`

### 常用环境变量
```bash
# API 配置
ANTHROPIC_API_KEY=key              # API key
ANTHROPIC_AUTH_TOKEN=token         # 认证 token
ANTHROPIC_BASE_URL=url             # API endpoint

# 模型配置
ANTHROPIC_MODEL=model-name         # 指定模型

# 其他配置
CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1  # 禁用非必要流量
```

### 验证配置的步骤
1. 编辑 `agents.json`
2. 重启 MindFS 服务
3. 在浏览器中打开 MindFS
4. 检查 Agent 列表显示状态
5. 创建新会话测试功能

### 故障排查
- **Agent 显示不可用**：检查网络连接和 API 凭证
- **模型列表为空**：确认 API endpoint 正确
- **认证失败**：验证 key/token 的有效性
- **响应缓慢**：检查网络延迟和服务器状态

---

## 配置示例合集

### 示例 1：基础 API Key 配置
```json
{
  "agents": [
    {
      "name": "claude",
      "command": "claude",
      "protocol": "claude-sdk",
      "env": {
        "ANTHROPIC_API_KEY": "sk-ant-your-key-here"
      }
    }
  ]
}
```

### 示例 2：第三方 API 配置（推荐）
```json
{
  "agents": [
    {
      "name": "claude-official",
      "command": "claude",
      "protocol": "claude-sdk",
      "env": {
        "ANTHROPIC_API_KEY": "sk-ant-your-key"
      }
    },
    {
      "name": "claude-glm",
      "command": "claude",
      "protocol": "claude-sdk",
      "env": {
        "ANTHROPIC_BASE_URL": "https://open.bigmodel.cn/api/anthropic",
        "ANTHROPIC_API_KEY": "your-glm-key",
        "ANTHROPIC_MODEL": "glm-4-plus"
      }
    }
  ]
}
```

### 示例 3：完全替换为第三方
```json
{
  "agents": [
    {
      "name": "claude",
      "command": "claude",
      "protocol": "claude-sdk",
      "env": {
        "ANTHROPIC_BASE_URL": "https://open.bigmodel.cn/api/anthropic",
        "ANTHROPIC_AUTH_TOKEN": "your-glm-token"
      }
    }
  ]
}
```

### 示例 4：多 Agent 配置（实战案例）
```json
{
  "agents": [
    {
      "name": "claude",
      "command": "claude",
      "protocol": "claude-sdk"
    },
    {
      "name": "claude-deepseek-flash",
      "command": "claude",
      "protocol": "claude-sdk",
      "env": {
        "ANTHROPIC_API_KEY": "sk-74c6d3beeb754b38ade717217a40b9a2",
        "ANTHROPIC_BASE_URL": "https://api.deepseek.com/anthropic",
        "ANTHROPIC_MODEL": "deepseek-v4-flash"
      }
    },
    {
      "name": "claude-deepseek-pro",
      "command": "claude",
      "protocol": "claude-sdk",
      "env": {
        "ANTHROPIC_API_KEY": "sk-74c6d3beeb754b38ade717217a40b9a2",
        "ANTHROPIC_BASE_URL": "https://api.deepseek.com/anthropic",
        "ANTHROPIC_MODEL": "deepseek-v4-pro"
      }
    },
    {
      "name": "claude-mimo-pro",
      "command": "claude",
      "protocol": "claude-sdk",
      "env": {
        "ANTHROPIC_API_KEY": "tp-c823w3ub9bbd6hrrmvnwlw6glyxaehsrn387cnmr4ce73271",
        "ANTHROPIC_BASE_URL": "https://token-plan-cn.xiaomimimo.com/anthropic",
        "ANTHROPIC_MODEL": "mimo-v2.5-pro"
      }
    },
    {
      "name": "claude-glm-5.1",
      "command": "claude",
      "protocol": "claude-sdk",
      "env": {
        "ANTHROPIC_AUTH_TOKEN": "62d4531d3cf74db0b3c8764ad7a4f86d.5lohk8um0tdydGYF",
        "ANTHROPIC_BASE_URL": "https://open.bigmodel.cn/api/anthropic",
        "ANTHROPIC_MODEL": "glm-5.1"
      }
    }
  ]
}
```

---

**文档生成时间：** 2025-01-07  
**最后更新时间：** 2026-05-08  
**基于对话内容：** MindFS 与 Claude Code 集成配置技术讨论 + 多 Agent 实战配置  
**适用版本：** MindFS 当前版本 + Claude Code CLI  
**文档用途：** 配置参考、故障排查指南和多 Agent 管理手册

**更新内容：**
- ✅ 新增多 Agent 配置实战案例
- ✅ 添加配置文件优先级说明  
- ✅ 补充重启管理脚本
- ✅ 完善故障排查指南
- ✅ 增加 DeepSeek、MiMo、智谱 GLM 等第三方服务配置示例