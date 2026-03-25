# Superpowers for OpenClaw

> 将 [obra/superpowers](https://github.com/obra/superpowers) 移植为 [OpenClaw](https://github.com/openclaw/openclaw) 原生 skill，适配多 Agent、多 Channel 架构。

**一句话概括**：给你的 OpenClaw agent 装上结构化开发工作流——从脑暴到设计、从 TDD 到 code review，全链路自动化。

## 安装

```bash
# 方式 1：直接复制
cp -r superpowers/ ~/.openclaw/skills/superpowers/

# 方式 2：Git clone
git clone https://github.com/ayoporridge/superpowers.git ~/.openclaw/skills/superpowers/

# 方式 3：软链接（方便开发迭代）
git clone https://github.com/ayoporridge/superpowers.git ~/superpowers
ln -s ~/superpowers ~/.openclaw/skills/superpowers
```

安装后 OpenClaw 自动发现并加载，无需额外配置。

## 工作流一览

```
brainstorming → writing-plans → subagent-dev / executing-plans → request-review → finish-branch
     ↓               ↓                 ↓                              ↓
  Spec review    Plan review    Per-task: implement                Code review
  (subagent)     (subagent)     → spec review → quality review     (subagent)
```

贯穿始终的横切模式：**TDD**（永远先写测试）、**verification**（完成前必须有证据）、**debugging**（系统化根因分析）。

## 13 个模式

| 模式 | 触发场景 | 说明 |
|------|---------|------|
| `brainstorming` | 新功能 / 设计需求 | Socratic 问答 → 多方案对比 → 写 spec → 审查循环 |
| `writing-plans` | Spec 通过，准备规划 | 拆成 2-5 分钟的 bite-sized task，含完整代码示例 |
| `executing-plans` | 有 plan，串行执行 | 逐任务执行 + tracker 跟踪进度 |
| `subagent-dev` | 有 plan + coding-agent 可用 | ⭐ 每任务独立 coding-agent + 双阶段审查 |
| `parallel-dispatch` | 3+ 独立任务 | 多 coding-agent 并行，各自独立 worktree |
| `tdd` | 任何代码编写 | RED-GREEN-REFACTOR，铁律：无测试不写码 |
| `debugging` | Bug / 测试失败 | 四阶段根因分析，3 次失败即停 |
| `verification` | 即将声称 "完成" | 必须有 fresh 验证证据，禁止 "should work" |
| `git-worktrees` | 需要隔离开发环境 | 安全的 worktree 创建 + gitignore 检查 |
| `finish-branch` | 开发完成 | 4 选项：merge / PR / 保留 / 丢弃 |
| `receive-review` | 收到 review 反馈 | 先验证再实现，拒绝表演式认同 |
| `request-review` | 需要 code review | 调度 reviewer agent，按严重级处理反馈 |
| `writing-skills` | 创建 / 编辑 skill | OpenClaw skill 结构指南 |

## 相比原版的 OpenClaw 增强

原版 Superpowers 是为 Claude Code / Cursor 设计的单终端单 Agent 工具。OpenClaw 版利用了平台原生能力：

| 能力 | 原版 (CC/Cursor) | OpenClaw 版 |
|------|-----------------|-------------|
| Subagent 执行 | `Agent` tool（同进程） | `coding-agent background:true`（独立进程） |
| 任务跟踪 | `TodoWrite`（内存） | `tracker.md`（持久化文件） |
| 并行开发 | 不支持 | 多 coding-agent + 独立 worktree |
| Agent 间通信 | 无 | `sessions_send` / `sessions_history` |
| 进度通知 | 无（只能看终端） | 推送到 Telegram / Slack / Discord |
| 断线续跑 | 无 | Cron 定时检查 + Gateway 持久化 |
| 人工卡点 | 难以实现 | Standing Order approval-gate |

### 双执行模式

**Safe Mode（默认）**：串行执行，与原版一致，适合有依赖的任务链。

**Parallel Mode**：独立任务分发到多个 coding-agent，各自在隔离 worktree 中工作，完成后用 `scripts/check-conflicts.sh` 检测冲突再合并。

### 进度广播

```bash
# 配置 cron 定期检查 plan 进度
openclaw cron add --name "superpowers-check" --every "30m" \
  --session main --system-event "Check superpowers tracker progress"
```

关键节点自动推送：✅ 任务完成 · 🚫 任务阻塞 · 📝 Spec/Plan 待审 · 🔀 PR 创建 · 🏁 全部完成

## 项目结构

```
superpowers/
├── SKILL.md                     # 主入口：核心原则 + 模式索引 + 调度逻辑
├── references/
│   ├── modes/                   # 13 个工作流模式
│   │   ├── brainstorming.md
│   │   ├── writing-plans.md
│   │   ├── executing-plans.md
│   │   ├── subagent-driven-development.md   ← 核心改造
│   │   ├── dispatching-parallel-agents.md
│   │   ├── test-driven-development.md
│   │   ├── systematic-debugging.md
│   │   ├── verification-before-completion.md
│   │   ├── using-git-worktrees.md
│   │   ├── finishing-a-development-branch.md
│   │   ├── receiving-code-review.md
│   │   ├── requesting-code-review.md
│   │   └── writing-skills.md
│   └── prompts/                 # 6 个 subagent prompt 模板
│       ├── implementer-prompt.md
│       ├── spec-reviewer-prompt.md
│       ├── code-quality-reviewer-prompt.md
│       ├── code-reviewer-prompt.md
│       ├── spec-document-reviewer-prompt.md
│       └── plan-document-reviewer-prompt.md
├── scripts/
│   └── check-conflicts.sh       # 并行 agent 冲突检测
└── assets/                      # 文档模板
    ├── plan-template.md
    ├── spec-template.md
    └── tracker-template.md
```

## 致谢

- [obra/superpowers](https://github.com/obra/superpowers) — Jesse Vincent 的原版框架
- [OpenClaw](https://github.com/openclaw/openclaw) — 底层 AI 助手平台

## License

MIT
