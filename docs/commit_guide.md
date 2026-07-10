# Commit & MR 规范

> openruyi-autotest 项目的 Commit 信息规范和 Merge Request 规范。
> 遵循 [Conventional Commits](https://www.conventionalcommits.org/) 业界标准。

---

## 1. Commit 信息规范

### 1.1 基本格式

```
<type>(<scope>): <short summary>

<optional body>

<optional footer>
```

- **type**: 提交类型（必填）
- **scope**: 影响范围（可选，建议填写）
- **short summary**: 简短描述，不超过 72 字符，英文小写，不以句号结尾
- **body**: 详细说明（可选），与 summary 之间空一行
- **footer**: 脚注（可选），如 `BREAKING CHANGE:` 或关联 issue

### 1.2 Type 类型

| Type | 说明 | 示例 |
|------|------|------|
| `feat` | 新功能 | `feat: add default hardware-require to all test suites` |
| `fix` | Bug 修复 | `fix: hw_check.sh awk pattern to match indented YAML keys` |
| `docs` | 文档变更 | `docs: enhance development guide with ACL walkthrough` |
| `style` | 代码格式（不影响逻辑） | `style: fix shellcheck warnings in lib.sh` |
| `refactor` | 重构（非新功能、非修 bug） | `refactor: move config resolution into main()` |
| `perf` | 性能优化 | `perf: cache dnf metadata in test setup` |
| `test` | 测试用例变更 | `test: add getfacl error handling test cases` |
| `chore` | 构建/工具/依赖变更 | `chore: remove qemu_daemon.py` |
| `ci` | CI/CD 变更 | `ci: add shellcheck to pre-commit hooks` |
| `build` | 构建系统变更 | `build: update tmt to 1.75.0` |

### 1.3 Scope 范围（可选）

建议使用受影响的模块或目录名：

| Scope | 含义 |
|-------|------|
| `acl` | acl 测试套 |
| `kernel` | 内核测试 |
| `hw_check` | 硬件检查库 |
| `ltp` | LTP 测试套 |
| `plan` | 测试计划 |
| `tmt` | tmt 框架配置 |
| _(省略)_ | 影响范围不明确或跨模块时可不写 |

### 1.4 示例

```bash
# 基本格式
feat(acl): add chacl command test suite

# 带 body
fix(kernel): resolve sched_attr redefinition in LTP 20260529

The sched_attr struct was redefined in the 20260529 tag. Use
range-based sed to patch only the conflicting definition without
affecting other uses of the struct.

# 破坏性变更
feat(config)!: switch from YAML to TOML for topology config

BREAKING CHANGE: topology.env is now topology.toml.
All existing topology.env files must be migrated.
```

### 1.5 注意事项

- **summary 使用纯 ASCII 英文**（Gitea 不支持中文 Commit 信息）
- summary 不超过 72 字符
- 使用祈使语气：`add` 而非 `added`，`fix` 而非 `fixed`
- 每个 commit 只做一件事，避免混合无关变更
- 提交前用 `git diff --cached` 检查暂存区

---

## 2. Merge Request 规范

### 2.1 MR 标题

遵循与 Commit 相同的 Conventional Commits 格式：

```
<type>(<scope>): <short summary>
```

示例：

```
docs: enhance development guide - hardware-require, test discovery, ACL walkthrough
feat(ltp): add 65 functional test suites with kirk runner
fix(hw_check): correct awk field parsing for indented YAML
```

### 2.2 MR 描述模板

```markdown
## Summary

Briefly describe what this MR does and why.

## Changes

- Change 1: description
- Change 2: description
- Change 3: description

## Verification

- [ ] Local bash test.sh passes
- [ ] tmt run passes for affected tests
- [ ] No regressions in existing tests

## Related Issues

Closes #123
Refs: #456
```

### 2.3 MR 描述示例

```markdown
## Summary

This PR comprehensively enhances `docs/development-guide.md` (+448/-36 lines),
covering structural additions, environment constraints documentation,
verification checklist expansion, and an ACL development walkthrough.

## Changes

- Section 3.3.1: New test discovery mechanism diagram
- Section 3.4: lib.sh design patterns with reference counting
- Section 4: FMF field table now includes framework, hardware-require, environment
- Section 5.6: hwVerify placement documented (must be first line in Test Phase)
- Section 7: Verification checklist expanded from 5 to 8 items
- Section 8: FAQ expanded from 3 to 6 questions
- Section 9: Complete ACL development walkthrough with 3 full examples

## Verification

- [x] All examples syntax-checked with bash -n
- [x] tmt test ls confirms all referenced tests are discoverable
- [x] Document renders correctly in VS Code Markdown preview
```

### 2.4 注意事项

- **MR 标题和描述使用纯英文**（Gitea 不支持中文字符，会显示为乱码 `?`）
- MR 描述中避免使用反引号包裹的 Markdown 代码（Gitea 渲染可能异常），必要时用纯文本代替
- 一个 MR 聚焦一个主题，避免混合多个独立变更
- MR 合并前确保所有 CI 检查通过
- 合并方式推荐 **Rebase and Merge**（保持提交历史线性）

---

## 3. 分支命名规范

| 分支 | 用途 |
|------|------|
| `main` | 稳定版本，只接受 MR 合并 |
| `dev` | 开发主线，日常提交目标 |
| `feat/<name>` | 功能分支（可选，大功能开发时使用） |
| `fix/<name>` | 修复分支（可选，紧急修复时使用） |

日常开发流程：

```
git checkout dev
# ... 编码 ...
git add <files>
git commit -m "feat(scope): description"
git push origin dev
# 然后在 Gitea 上创建 dev → main 的 MR
```

---

## 4. 相关文档

- [开发指南](development-guide.md) — 测试用例开发完整流程
- [用户指南](user_guide.md) — 测试执行和使用说明
- [Conventional Commits 规范](https://www.conventionalcommits.org/en/v1.0.0/)
