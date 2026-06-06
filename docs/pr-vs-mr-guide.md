# Pull Request vs Merge Request: 代码合并请求详解

## 概述

Pull Request (PR) 和 Merge Request (MR) 是现代软件开发平台中用于**代码审查和分支合并**的核心机制。两者在功能上完全相同，但不同平台使用不同的术语。

```
┌─────────────────────────────────────────────────────────┐
│                   代码合并流程                          │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  功能分支 (feature/fix/refactor)                        │
│         │                                                │
│         ▼                                                │
│  ┌──────────────────┐                                    │
│  │  代码审查 (Review) │                                   │
│  └──────────────────┘                                    │
│         │                                                │
│         ▼                                                │
│  ┌──────────────────┐                                    │
│  │  合并到主分支     │                                   │
│  └──────────────────┘                                    │
│                                                          │
└─────────────────────────────────────────────────────────┘

不同平台的叫法:
  GitHub      → Pull Request  (PR)
  GitLab      → Merge Request (MR)
  Bitbucket    → Pull Request  (PR)
```

---

## 术语对比

| 平台 | 术语 | 缩写 | 使用时间 |
|------|------|------|----------|
| **GitHub** | Pull Request | **PR** | 2008年至今 |
| **GitLab** | Merge Request | **MR** | 2011年至今 |
| Bitbucket | Pull Request | PR | 2011年至今 |
| Gitee/Giteos | Merge Request | MR | - |
| Azure DevOps | Pull Request | PR | - |

**核心事实**: PR 和 MR 功能完全相同，只是叫法不同。

---

## 为什么叫 "Pull Request"？

### 历史背景

**Pull Request (拉取请求)** 是 **GitHub** 在 2008 年创立时引入的术语，是 GitHub 的标志性功能之一。

### 命名逻辑

```
┌─────────────────────────────────────────────────────────┐
│                GitHub 的协作理念                        │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  贡献者 (You)                    维护者 (Maintainer)      │
│      │                              │                   │
│      │ 提交 Pull Request             │                   │
│      ├─────────────────────────────>│                   │
│      │ "请拉取我的代码"              │                   │
│      │                              │ 决定是否 Pull    │
│      │                              │                   │
│      │                        [审查代码]              │
│      │                              │                   │
│      │                              │ [决定 Pull]      │
│      │                              ├───────┐           │
│      │                              ▼       │           │
│      │                         git pull your-branch  │
│      │                              │                   │
│      └──────────────────────────────┴───────────────┘
│                                                          │
└─────────────────────────────────────────────────────────┘
```

### 强调维护者的主动权

GitHub 的设计哲学：

> **"Pull Request emphasizes that the maintainer is in control."**
> 
> "Pull Request" 强调维护者有控制权。他们选择**拉取**你的代码，
> 而不是你强制他们**合并**你的代码。

#### 为什么不叫 "Merge Request"？

1. **控制权归属**
   - ❌ "Merge Request" 暗示：我请求你合并（你被请求了）
   - ✅ "Pull Request" 暗示：我请你拉取（你有选择权）

2. **协作理念**
   - 🤝 你**提供**代码更改
   - 🛡️ 维护者**审查**并决定是否采纳
   - 🎯 维护者**主动拉取**（Pull）你的代码

3. **Git 命令对应**
   ```bash
   # 贡献者的视角
   git push origin feature-branch
   
   # 维护者的视角
   git pull origin feature-branch  # 或 GitHub UI 点击 "Merge pull request"
   git merge feature-branch
   ```

---

## 为什么 GitLab 叫 "Merge Request"？

### GitLab 的理念

**GitLab** 在 2011 年创建时选择了不同的命名：

```
GitLab 的命名逻辑:
  "Merge Request" 更直接、更直观
  ↓
  明确表达意图：请求合并分支
  ↓
  减少理解成本
```

### 名称对比

| 术语 | 优点 | 缺点 |
|------|------|------|
| **Pull Request** | 强调协作、维护者控制权 | 对新手不够直观 |
| **Merge Request** | 直接、清晰表达意图 | 没强调控制权归属 |

### 实际操作相同

```bash
# GitHub (Pull Request)
1. 创建 PR
2. 审查代码
3. 点击 "Merge pull request"
4. GitHub 执行: git merge

# GitLab (Merge Request)  
1. 创建 MR
2. 审查代码
3. 点击 "Merge"
4. GitLab 执行: git merge
```

**结果完全相同**：代码被合并到目标分支。

---

## 功能对比

### 相同点（功能 100% 相同）

```
┌─────────────────────────────────────────────────────────┐
│                  PR 和 MR 的共同功能                      │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  ✓ 代码审查 (Code Review)                              │
│  ✓ 讨论评论 (Discussion)                                │
│  ✓ 自动化测试 (CI/CD)                                  │
│  ✓ 修改建议 (Review Suggestions)                         │
│  ✓ 批准流程 (Approval Workflows)                         │
│  ✓ 状态检查 (Status Checks)                             │
│  ✓ 分支保护 (Branch Protection)                           │
│  ✓ 代码冲突解决 (Conflict Resolution)                     │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

### 不同点（主要是品牌差异）

```
GitHub (PR):
├── 术语: Pull Request
├── 颜色: "Simplify the world from software"
├── 社区: 开源项目为主
└── 特色: 
    ├── GitHub Actions (CI/CD)
    ├── Code Owners
    └── 强调社区协作

GitLab (MR):
├── 术语: Merge Request
├── 颜色: "DevOps platform"
├── 用户: 企业团队为主
└── 特色:
    ├── Built-in CI/CD
    ├── Approvals (更灵活的审批)
    └── 强调企业级 DevOps
```

---

## 实际使用示例

### GitHub 创建 PR

```bash
# 1. 创建功能分支
git checkout -b feature/add-login

# 2. 提交更改
git add .
git commit -m "Add login feature"

# 3. 推送分支
git push -u origin feature/add-login

# 4. 创建 PR (三种方式)
# 方式 A: GitHub CLI
gh pr create --title "Add login feature" --body "描述更改..."

# 方式 B: 浏览器
# 访问: https://github.com/owner/repo/compare/main...feature/add-login

# 方式 C: Git 推送后自动提示
# git push 后终端会显示 PR 创建链接

# 5. 等待审查和合并
# 维护者审查代码 → 提出修改建议 → 你修改 → 重新推送
# 维护者满意后点击 "Merge pull request"

# 6. 删除分支
git branch -d feature/add-login
git push origin --delete feature/add-login
```

### GitLab 创建 MR

```bash
# 1. 创建功能分支
git checkout -b feature/add-login

# 2. 提交更改
git add .
git commit -m "Add login feature"

# 3. 推送分支
git push -u origin feature/add-login

# 4. 创建 MR (两种方式)
# 方式 A: GitLab CLI (glab)
glab mr create --title "Add login feature"

# 方式 B: 浏览器
# GitLab 推送后自动显示 MR 创建链接

# 5. 等待审查和合并
# 审查 → 修改 → 重新推送
# 管理员点击 "Merge"

# 6. 删除分支
git branch -d feature/add-login
git push origin --delete feature/add-login
```

---

## 常见问题解答

### Q1: PR 和 MR 功能有什么区别？

**A: 没有本质区别。**

- ✅ 两者都是**代码合并请求**
- ✅ 工作流程**完全相同**
- ✅ 只是**术语**不同
- ✅ 就像 "汽水" 和 "苏打水" - 本质一样，品牌不同

### Q2: 为什么不统一术语？

**A: 历史和品牌原因。**

- **GitHub** 在 2008 年创立 PR 术语，已有 15+ 年历史
- **GitLab** 在 2011 年创立时选择 MR 术语，建立品牌差异
- **很难统一**：涉及平台品牌、用户习惯、文化因素

### Q3: 我应该用哪个术语？

**A: 根据平台使用。**

```
在 GitHub 上 → 说 "Pull Request" 或 "PR"  ✓
在 GitLab 上 → 说 "Merge Request" 或 "MR"  ✓
通用交流   → 说 "PR/MR" 或 "代码合并请求"  ✓
```

**实际例子**：
- ✅ "我创建了一个 PR 来修复这个 bug"（GitHub）
- ✅ "请审查一下我的 MR"（GitLab）
- ✅ "这个 PR/MR 已经准备好合并了"（通用）

### Q4: 哪个更好？

**A: 功能相同，各有优势。**

| 方面 | GitHub PR | GitLab MR |
|------|-----------|------------|
| **知名度** | ✅ 更流行（GitHub 用户多） | ✅ 更直观（名称清晰） |
| **理念** | ✅ 强调协作和控制权 | ✅ 强调直接性 |
| **功能** | ✅ 相同 | ✅ 相同 |
| **社区** | ✅ 更大的开源社区 | ✅ 更强的企业市场 |

**结论**: 功能完全相同，只是平台术语差异。

---

## 最佳实践

### 通用规则（适用于 PR 和 MR）

#### ✅ DO（应该做的）

```markdown
1. 标题清晰
   ✓ "Fix: login page redirect issue"
   ✗ "Updates" (不明确)

2. 描述详细
   ✓ 说明更改原因、影响范围、测试方法

3. 小步提交
   ✓ 每个 PR/MR 只做一件事
   ✗ 不要混合多个无关更改

4. 及时响应
   ✓ 快速回复审查意见
   ✓ 及时修改并重新推送

5. 自测通过
   ✓ 本地确保测试通过
   ✓ 解决明显的代码问题
```

#### ❌ DON'T（不应该做的）

```markdown
1. 不要创建过大的 PR/MR
   ✗ 一次修改 50+ 个文件
   ✓ 拆分成多个小的 PR/MR

2. 不要忽略审查意见
   ✗ 不回复、不修改
   ✓ 说明原因或按建议修改

3. 不要包含无关更改
   ✗ 混合代码格式化和功能修改
   ✓ 保持 PR/MR 干净

4. 不要强制合并
   ✗ 不经过审查直接合并到 main
   ✓ 等待审查通过
```

---

## 术语速查表

| 术语 | 全称 | 平台 | 含义 |
|------|------|------|------|
| **PR** | Pull Request | GitHub, Bitbucket, etc. | 请求拉取代码合并 |
| **MR** | Merge Request | GitLab, Gitee, etc. | 请求合并分支 |
| **CR** | Code Review | 所有平台 | 代码审查 |
| **CI** | Continuous Integration | 所有平台 | 持续集成 |
| **CD** | Continuous Deployment | 所有平台 | 持续部署 |

---

## 实际场景

### 场景 1: 开源项目（GitHub）

```
贡献者 (Community)          项目维护者 (Maintainer)
      │                                │
      │ 创建 PR                       │
      ├────────────────────────────>│
      │  "Add dark mode support"      │
      │                              │ 审查代码
      │                              │ ↓
      │                        [请求修改]
      │                              │ ↓
      │  修改代码                        │
      │  重新推送                        │
      │                              │ 审查通过
      │                              │ ↓
      │                              │ 点击 "Merge pull request"
      │                              │ ↓
      └──────────────────────────────┴ PR 合并到 main
```

### 场景 2: 企业团队（GitLab）

```
开发者 (Developer)             技术主管 (Tech Lead)
      │                              │
      │ 创建 MR                       │
      ├────────────────────────────>│
      │  "Refactor database layer"    │
      │                              │ 指定审查者
      │                              │ ↓
      │                        [团队审查]
      │                              │ ↓
      │ 修改代码                        │
      │ 重新推送                        │
      │                              │ 审查通过
      │                              │ ↓
      │                              │ 点击 "Merge"
      │                              │ ↓
      └──────────────────────────────┴ MR 合并到 main
```

---

## 总结

### 核心要点

1. **PR 和 MR 功能完全相同** - 都是代码合并请求
2. **只是术语差异** - GitHub 用 PR，GitLab 用 MR
3. **历史原因** - GitHub 在 2008 年创立 PR，GitLab 在 2011 年创立 MR
4. **命名哲学** - PR 强调协作和控制权，MR 强调直接性
5. **实际使用** - 根据平台使用对应术语

### 记忆口诀

```
GitHub → Pull Request (PR)  → Pull me your code
GitLab  → Merge Request (MR) → Merge my branch

功能相同，术语不同
平台差异，品牌区分
```

---

## 参考资料

- [GitHub Pull Request 文档](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests)
- [GitLab Merge Request 文档](https://docs.gitlab.com/ee/user/project/merge_requests/)
- [Bitbucket Pull Request 文档](https://confluence.atlassian.com/bitbucketserver/pull-requests-for-code-reviews-780527655.html)
- [PR vs MR: What's the Difference?](https://www.gitlab.com/blog/unlock-the-gitlab-user-experience/merge-request-pull-request/)

---

**文档版本**: 1.0  
**最后更新**: 2026-05-05  
**作者**: MindFS 项目
