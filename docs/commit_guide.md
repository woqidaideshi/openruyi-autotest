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

---

## 5. 实战演示：以 ACL 测试套为例

以下以 `tests/functional/pkgs/acl/` 测试套为例，展示从新增、修改、修复到重构的完整 Commit 和 MR 写法。

ACL 测试套结构：

```
tests/functional/pkgs/acl/
├── main.fmf                     # 套件级元数据
├── lib.sh                       # 共享库（引用计数安装/卸载）
├── test_acl_getfacl_basic/      # getfacl 基本功能（7 个参数）
├── test_acl_setfacl_basic/      # setfacl 增删改查
├── test_acl_setfacl_advanced/   # default ACL、--set、-M
├── test_acl_setfacl_recursive/  # -R 递归设置
├── test_acl_setfacl_remove/     # -x/-X 批量删除
├── test_acl_setfacl_symlink/    # -L/-P 符号链接处理
├── test_acl_chacl_command/      # chacl 命令
├── test_acl_acl_inheritance/    # 默认 ACL 继承
├── test_acl_acl_permission_verify/  # ACL 权限实际生效验证
├── test_acl_error_handling/     # 错误路径（不存在文件/用户/无效权限）
└── test_acl_special_cases/      # 多用户多组、--test 试运行、备份恢复
```

### 5.1 场景一：新增测试用例

**场景**：为 ACL 套件新增 `getfacl` 基本功能测试，覆盖 7 个命令行参数。

**涉及文件**：

| 操作 | 文件 |
|------|------|
| 新增 | `tests/functional/pkgs/acl/test_acl_getfacl_basic/main.fmf` |
| 新增 | `tests/functional/pkgs/acl/test_acl_getfacl_basic/test.sh` |

**Commit**：

```bash
git add tests/functional/pkgs/acl/test_acl_getfacl_basic/
git commit -m "feat(acl): add getfacl basic test covering 7 CLI options"
```

**Commit 要点解析**：

| 要素 | 值 | 说明 |
|------|-----|------|
| type | `feat` | 新增功能（新测试用例 = 新功能） |
| scope | `acl` | 影响 acl 测试套 |
| summary | `add getfacl basic test covering 7 CLI options` | 47 字符，祈使语气，说明覆盖面 |

### 5.2 场景二：修改/更新现有测试

**场景**：在 `test_acl_error_handling` 中增加两个新的错误路径：`setfacl` 设置无效 mask 值、`getfacl` 对无权限文件的处理。

**涉及文件**：

| 操作 | 文件 |
|------|------|
| 修改 | `tests/functional/pkgs/acl/test_acl_error_handling/test.sh` |

**Commit**：

```bash
git add tests/functional/pkgs/acl/test_acl_error_handling/test.sh
git commit -m "feat(acl): add invalid mask and permission-denied error cases"
```

**Commit 要点解析**：

| 要素 | 值 | 说明 |
|------|-----|------|
| type | `feat` | 增加了新功能点（错误路径覆盖面扩大） |
| scope | `acl` | 影响 acl 测试套 |

> **注意**：如果只是修改测试描述文案、注释或格式，用 `style` 或 `refactor` 而非 `feat`。

### 5.3 场景三：Bug 修复

**场景**：发现 `test_acl_setfacl_basic` 中 `rlRun "! getfacl ... | grep ..."` 的退出码逻辑错误 —— 反引号 `!` 在 `rlRun` 中不会如预期工作，导致用例误报 PASS。

**涉及文件**：

| 操作 | 文件 |
|------|------|
| 修改 | `tests/functional/pkgs/acl/test_acl_setfacl_basic/test.sh` |

**Commit**：

```bash
git add tests/functional/pkgs/acl/test_acl_setfacl_basic/test.sh
git commit -m "fix(acl): correct exit code check in setfacl_basic negative tests"
```

**Commit 要点解析**：

| 要素 | 值 | 说明 |
|------|-----|------|
| type | `fix` | 修复 bug |
| scope | `acl` | 影响 acl 测试套 |

### 5.4 场景四：重构

**场景**：将 ACL 测试套从单一巨大脚本拆分为 11 个独立用例目录，每个用例拥有自己的 `main.fmf` 和 `test.sh`。同时提取共享安装/卸载逻辑到 `lib.sh`。

**涉及文件**：

| 操作 | 数量 | 说明 |
|------|------|------|
| 删除 | ~5 | 旧的 `setup.sh`、`teardown.sh`、`test.sh` |
| 新增 | 12 | `lib.sh` + 11 个 `test_acl_*/main.fmf` |
| 修改 | 12 | 11 个 `test_acl_*/test.sh` + `main.fmf` |

**Commit**：

```bash
git add tests/functional/pkgs/acl/
git commit -m "refactor(acl): split into per-case dirs with shared lib.sh"
```

**Commit 要点解析**：

| 要素 | 值 | 说明 |
|------|-----|------|
| type | `refactor` | 重构，不改变测试逻辑 |
| scope | `acl` | 影响 acl 测试套 |

### 5.5 场景五：文档更新

**场景**：在开发指南中新增 ACL 开发实战示例章节。

**Commit**：

```bash
git add docs/development-guide.md
git commit -m "docs: add ACL development walkthrough to developer guide"
```

**Commit 要点解析**：

| 要素 | 值 | 说明 |
|------|-----|------|
| type | `docs` | 文档变更 |
| scope | _(省略)_ | 跨模块文档，无需 scope |

---

### 5.6 场景六：ACL 套件的完整 MR

以上 5 个 Commit 合在一起，创建一个 `dev → main` 的 MR：

**MR 标题**：

```
feat(acl): add getfacl and error-handling tests, fix exit code bug, refactor to per-case dirs
```

**MR 描述**：

```markdown
## Summary

This MR enhances the ACL test suite with new test cases, bug fixes,
and a structural refactoring for better maintainability.

Related commits in this MR:
- feat(acl): add getfacl basic test covering 7 CLI options
- feat(acl): add invalid mask and permission-denied error cases
- fix(acl): correct exit code check in setfacl_basic negative tests
- refactor(acl): split into per-case dirs with shared lib.sh
- docs: add ACL development walkthrough to developer guide

## Changes

### New Tests
- getfacl basic: covers -a, -d, -c, -n, -t options (7 features)
- error handling: added invalid mask and permission-denied edge cases

### Bug Fixes
- Fixed rlRun exit code logic in setfacl_basic negative tests
  (the ! negation operator does not work inside rlRun)

### Refactoring
- Split monolithic ACL test into 11 independent per-case directories
- Extracted shared package install/uninstall into lib.sh
- Each test case now has its own main.fmf with granular duration/tier

### Documentation
- Added Section 9 to development-guide.md with ACL walkthrough

## Verification

- [x] All 11 ACL test cases pass: tmt run plan --name /plans/functional test --name /tests/functional/pkgs/acl
- [x] Each case runs independently without side effects
- [x] lib.sh reference counting works correctly (acl installed once, uninstalled once)
- [x] No regressions in other functional test suites
- [x] getfacl basic covers all 7 CLI options
- [x] Error cases correctly report FAIL for invalid input
```

**MR 要点解析**：

| 要素 | 说明 |
|------|------|
| 标题 | 概括 MR 主题，用逗号分隔各子主题 |
| Summary | 一句话概述 + 关联的 commit 列表 |
| Changes | 按类别分组（New / Fix / Refactor / Docs），每项具体说明 |
| Verification | 列出验证步骤和结果，每个 check 都具体可复现 |

