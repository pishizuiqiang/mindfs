# Relay 相关提交跳过清单

## 背景
我们的 `remove-relay-mode` 变更正在移除 relay 远程访问模式功能，因此需要识别并跳过主要涉及 relay 功能的上游提交。

## 需要跳过的提交

### 1. 直接冲突的 Relay 提交

#### `f13a451` - fix: android notification bug with relay mode
- **跳过原因**: 直接涉及 Android relay 模式的通知功能
- **影响范围**: Android app (`MainActivity.java`, `Makefile`)
- **冲突分析**: 修改了与 relay 相关的 Android 通知逻辑
- **处理方式**: 完全跳过，我们的变更已移除相关功能

#### `41055c0` - refine: make relay binding explicit and handle relay WS navigation failures  
- **跳过原因**: 使 relay 绑定显式化并处理 relay WebSocket 导航失败
- **影响范围**: 可能涉及配置文件和 WebSocket 处理
- **冲突分析**: 增加了 relay 相关的配置和错误处理
- **处理方式**: 完全跳过，与我们的 relay 移除冲突

### 2. 潜在包含 Relay 代码的提交

以下提交可能包含 relay 相关代码，需要 cherry-pick 时手动检查：

#### `533c5e7` - refine: static asset loading under relay mode
- **状态**: 需要检查，可能包含静态资源加载逻辑
- **处理方式**: 手动检查后决定是否包含部分代码

#### 其他可能涉及 relay 的配置或文档提交
- 检查 README 中的 relay 功能描述
- 检查配置文件中的 relay 相关字段

## Cherry-pick 策略

### 自动跳过规则
1. 提交标题包含 "relay" 关键词
2. 提交主要修改 relay 相关文件 (`server/internal/relay/`)
3. 提交增加 relay 配置选项或字段

### 手动检查规则
1. 提交同时包含 relay 和其他功能的修改
2. 提交涉及配置文件可能包含 relay 字段
3. 提交影响 Android app 的网络相关功能

### 手动合并规则
1. 如果提交包含 relay + 其他有价值功能
2. 手动编辑冲突，只保留非 relay 部分
3. 确保不引入任何 relay 依赖或引用

## 冲突处理预案

### 场景 1: 文件级冲突
- **问题**: 文件在我们分支和上游都被修改
- **解决**: 手动合并，移除 relay 相关代码

### 场景 2: 配置文件冲突  
- **问题**: 配置文件增加 relay 字段
- **解决**: 使用我们的配置结构，忽略 relay 字段

### 场景 3: 依赖关系冲突
- **问题**: 某个提交依赖我们跳过的 relay 提交
- **解决**: 手动移除依赖关系或寻找替代方案

## 验证清单

在完成所有批次合并后，验证：

- [ ] 代码库中不存在 `server/internal/relay/` 目录
- [ ] 配置文件中不包含 relay 相关字段
- [ ] 文档中不描述 relay 功能（除非作为历史说明）
- [ ] Android app 不包含 relay 相关代码
- [ ] 构建和运行时没有 relay 相关错误或警告

## 记录保持

每个跳过的提交都应在此文档中记录：
- 提交哈希和标题
- 跳过原因
- 潜在影响评估
- 是否有替代解决方案