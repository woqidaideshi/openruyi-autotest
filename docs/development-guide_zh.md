# openruyi-autotest 开发指南

> 如何为 openruyi-autotest 贡献新的测试用例。
>
> **相关文档**：[Commit & MR 规范](commit_guide_zh.md) · [用户指南](user_guide_zh.md)

> :us: [English Version (英文版)](development-guide.md)

---

## 1. 测试框架概述

openruyi-autotest 基于 [tmt (Test Management Tool)](https://tmt.readthedocs.io/) 框架，使用 [BeakerLib](https://github.com/beakerlib/beakerlib) 编写测试脚本，通过 [FMF (Flexible Metadata Format)](https://fmf.readthedocs.io/) 管理元数据。

### 核心概念

| 概念 | 说明 | 文件 |
|------|------|------|
| **测试计划 (Plan)** | 定义如何发现、准备、执行和报告测试 | `plans/*.fmf` |
| **测试用例 (Test)** | 具体的测试脚本 + 元数据 | `tests/**/test.sh` + `main.fmf` |
| **FMF 元数据** | YAML 格式的测试描述信息 | `main.fmf` |
| **BeakerLib** | Shell 测试框架，提供 rlRun/rlAssertGrep 等原语 | 脚本中 `. /usr/share/beakerlib/beakerlib.sh` |

---

## 2. 目录约定

```
tests/
├── main.fmf                     # 全局共享配置（framework, duration 等）
├── smoke/                       # 冒烟测试
│   ├── main.fmf                 # 冒烟级共享配置
│   └── <category>/              # 分类目录
│       ├── main.fmf             # 分类共享配置
│       ├── lib.sh               # 分类级共享库（可选）
│       └── test_smoke_<name>/   # 测试用例目录
│           ├── main.fmf         # 用例元数据
│           └── test.sh          # 用例脚本
├── functional/                  # 功能测试
│   ├── main.fmf                 # 功能级共享配置
│   └── pkgs/                    # RPM 软件包测试
│       └── <pkg>/               # 软件包目录
│           ├── main.fmf         # 包级元数据
│           ├── lib.sh           # 包级共享库（可选）
│           └── test_<pkg>_<feature>/  # 功能测试用例
│               ├── main.fmf
│               └── test.sh
├── security/                    # 安全测试
├── compatibility/               # 兼容性测试
├── performance/                 # 性能测试
├── feature/                     # 特性测试
│   ├── main.fmf                 # 特性级共享配置
│   └── <xxx>/                   # 特性名称（如 gpu、network）
│       ├── main.fmf             # 特性级元数据
│       └── test_feature_<aaa>/  # 特性测试用例（aaa 为具体描述）
│           ├── main.fmf
│           └── test.sh
└── reliability/                 # 可靠性测试
```

---

## 3. 添加新测试用例

### 3.1 创建目录和文件

以在 acl 软件包下新增一个测试用例为例：

```bash
# 1. 创建测试用例目录
mkdir -p tests/functional/pkgs/acl/test_acl_my_feature

# 2. 创建元数据文件
cat > tests/functional/pkgs/acl/test_acl_my_feature/main.fmf << 'EOF'
summary: 功能测试 - acl - 我的功能
test: ./test.sh
framework: shell
tag:
  - functional
  - acl
duration: 2m
tier: 1
path: /tests/functional/pkgs/acl/test_acl_my_feature
require:
  - acl
  - coreutils
  - beakerlib
EOF
```

> **字段说明**：`framework: shell` 声明使用 Shell 测试框架；`tag: [functional, acl]` 确保被 functional plan 发现；`duration` 可覆盖父级默认值；`require` 除被测包外还需 `coreutils`（创建文件/目录等基础操作）和 `beakerlib`（测试框架）。

### 3.2 编写测试脚本

```bash
cat > tests/functional/pkgs/acl/test_acl_my_feature/test.sh << 'TESTEOF'
#!/bin/bash
# Functional test: acl - my feature
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        aclSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
        rlRun "touch testfile" 0 "创建测试文件"
        rlRun "mkdir testdir" 0 "创建测试目录"
    rlPhaseEnd

    rlPhaseStartTest "我的功能测试"
        # 功能点 1: 基本验证
        rlRun "getfacl testfile" 0 "查看文件默认 ACL"

        # 功能点 2: 设置 ACL
        rlRun "setfacl -m u:root:rwx testfile" 0 "设置用户 ACL"
        rlRun "getfacl testfile 2>&1 | grep -q 'user:root:rwx'" 0 "确认 ACL 已设置"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # acl 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
TESTEOF
```

> **`rlRun` 退出码规则**：第二个参数 `0` 表示期望命令成功（退出码 0），`1` 表示期望命令失败（用于负向测试）。如果实际退出码与期望不符，rlRun 会报告 FAIL 并阻止后续 Phase 执行。

### 3.3 BeakerLib 生命周期

每个测试脚本遵循标准的三阶段结构：

| 阶段 | 函数 | 用途 |
|------|------|------|
| **Setup** | `rlPhaseStartSetup` | 环境准备：安装软件包、创建临时目录、调用 `*Setup()` 共享库函数 |
| **Test** | `rlPhaseStartTest` | 执行测试：调用被测试命令、断言结果。可包含多个 Phase，每个测试一个功能点 |
| **Cleanup** | `rlPhaseStartCleanup` | 清理环境：删除临时文件、返回原目录、共享库自动管理软件包卸载 |

> **注意**：`rlPhaseStartSetup` 中调用的 `aclSetup()` 通过 `rlCleanupAppend` 向 BeakerLib 注册了清理回调，所以 Cleanup 阶段**不需要**手动卸载软件包。

### 3.3.1 测试如何被 tmt 发现？

tmt 的执行流程是：Plan 的 `discover` 阶段遍历 `tests/` 目录树，通过 FMF 的 `tag` 匹配找到所有符合条件的测试用例。

```
tmt run plan --name /plans/functional
  │
  ├─ [discover] plans/functional.fmf → filter: "tag:functional"
  │   │
  │   ├─ 遍历 tests/ 树，匹配 tag 含 "functional" 的所有 main.fmf
  │   │  ✓ tests/functional/pkgs/acl/test_acl_getfacl_basic/main.fmf
  │   │  ✓ tests/functional/pkgs/acl/test_acl_setfacl_basic/main.fmf
  │   │  ✗ tests/smoke/archive/main.fmf              (tag: smoke)
  │   │  ✗ tests/security/cve/main.fmf               (tag: security)
  │   │
  │   └─ 输出: 202 个测试被发现
  │
  ├─ [execute] 按顺序执行每个 test.sh
  │
  └─ [report] 汇总结果
```

**要点**：
- `main.fmf` 中必须包含 `tag: [functional]`（或其他对应的计划标签）才能被对应 Plan 发现
- Plan 文件（如 `plans/functional.fmf`）通过 `filter: "tag:functional"` 声明匹配条件
- 不同 Plan 可以运行同一组测试（只需在 tag 中添加多个标签即可）
- 标签名来源于测试分类名：`smoke`、`functional`、`security`、`compatibility`、`performance`、`reliability`、`feature`

### 3.4 共享库（lib.sh）

当同一个软件包下多个测试用例需要共享安装/卸载逻辑时，使用 `lib.sh`。

**设计要点**：

- **`library-prefix` 注解**：文件头 `# library-prefix = acl` 声明函数前缀，所有公共函数以 `acl` 开头。
- **引用计数机制**：使用标志文件（如 `/tmp/.beakerlib_acl_suite`）跟踪有多少个测试用例正在使用该套件。第一个测试安装软件包，最后一个测试卸载。
- **`rlCleanupAppend`**：在 Setup 阶段注册 cleanup 函数，无论测试成功/失败，BeakerLib 都会在 `rlJournalEnd` 时自动调用。
- **`sudo` 处理**：项目使用 `echo <password> | sudo -S <cmd>` 模式注入 sudo 密码，`lib.sh` 中的安装/卸载命令需要适配。

**`lib.sh` 示例**：

```bash
# library-prefix = acl
#
# ACL suite-level shared library
# Usage in each test file:
#   . "$(dirname "$0")/../lib.sh"    # from test_acl_xxx/ subdirectories
#
# Then call:  aclSetup   in rlPhaseStartSetup
# The cleanup is auto-registered via rlCleanupAppend.

ACL_FLAG="/tmp/.beakerlib_acl_suite"

aclSetup() {
    if [ ! -f "$ACL_FLAG" ]; then
        if ! rpm -q acl 2>/dev/null; then
            echo openruyi | sudo -S dnf install -y acl 2>/dev/null
            echo "installed=1" > "$ACL_FLAG"
        else
            echo "installed=0" > "$ACL_FLAG"
        fi
        echo "ref=1" >> "$ACL_FLAG"
    else
        local ref=$(grep "^ref=" "$ACL_FLAG" | cut -d= -f2)
        ref=$((ref + 1))
        sed -i "s/^ref=.*/ref=$ref/" "$ACL_FLAG"
    fi
    rlCleanupAppend "aclCleanup"
}

aclCleanup() {
    [ ! -f "$ACL_FLAG" ] && return 0
    local ref=$(grep "^ref=" "$ACL_FLAG" | cut -d= -f2)
    ref=$((ref - 1))
    if [ "$ref" -le 0 ]; then
        grep -q "^installed=1" "$ACL_FLAG" && echo openruyi | sudo -S dnf remove -y acl 2>/dev/null || true
        rm -f "$ACL_FLAG"
    else
        sed -i "s/^ref=.*/ref=$ref/" "$ACL_FLAG"
    fi
}
```

---

## 4. FMF 元数据字段说明

### 测试用例 (main.fmf)

| 字段 | 类型 | 必填 | 说明 |
|------|------|:---:|------|
| `summary` | string | ✅ | 测试简短描述，格式：`测试类型 - 软件包 - 功能` |
| `test` | string | ✅ | 测试脚本路径，通常 `./test.sh` |
| `framework` | string | | 测试框架，`shell` 表示 Shell 脚本（继承自 `tests/main.fmf`） |
| `tag` | list | ✅ | 标签列表，如 `[functional, acl]`。Plan 通过 `filter: "tag:functional"` 匹配 |
| `duration` | string | ✅ | 预估执行时间，如 `2m`、`5m`。可覆盖父级默认值 |
| `tier` | int | ✅ | 优先级：0=冒烟(每次提交)，1=核心功能(每日)，2=扩展(发布前) |
| `path` | string | ✅ | 测试路径，格式 `/tests/<type>/pkgs/<pkg>/<test>` |
| `require` | list | ✅ | 依赖的 RPM 软件包（需含被测包 + `coreutils` + `beakerlib`） |
| `contact` | string | | 测试负责人 |
| `environment` | dict | | 自定义环境变量，如 `{VAR1: val1, VAR2: val2}`，注入到测试执行环境 |
| `extra-hardware-require` | dict | | 硬件需求声明（详见图 5.3），如 `{cpu: ">= 4", memory: ">= 8 GiB"}` |

### 测试计划 (plans/*.fmf)

```yaml
summary: 功能测试计划
discover:
  how: fmf
  test:
    - /tests/functional
provision:
  how: local
prepare:
  how: shell
  script:
    - echo ""
execute:
  how: tmt
```

---

## 5. 硬件环境约束

本项目所有 Plan 使用 `how: local` 模式，通过 **FMF 元数据声明 + 环境变量注入 + 公共库自检** 实现硬件环境约束。当环境不满足声明时，测试自动 SKIP（`exit 0`），不阻塞其他用例。

### 5.1 组件总览

| 组件 | 文件 | 作用 |
|------|------|------|
| 拓扑配置模板 | `topology.env.example` | 仓库级模板，提交到版本控制 |
| 拓扑配置实例 | `topology.env` | 实际服务器信息，已 `.gitignore`，不提交 |
| 测试用例声明 | `main.fmf` 中的 `extra-hardware-require` | 每个用例声明自己的硬件需求 |
| Plan 加载 | `plans/*.fmf` 中的 `environment-file` | 将 `topology.env` 注入为环境变量 |
| 公共检查库 | `tests/lib/hw_check.sh` | 解析声明、对比环境、远程执行 |

### 5.2 拓扑配置 (`topology.env`)

从 `topology.env.example` 复制为 `topology.env`，按实际环境修改：

```bash
TEST_SERVER_COUNT=2
TEST_SERVER_1_HOST=10.20.237.192
TEST_SERVER_1_PORT=12055
TEST_SERVER_1_USER=openruyi
TEST_SERVER_1_PASSWORD=openruyi
TEST_SERVER_2_HOST=10.20.238.100
TEST_SERVER_2_PORT=22
TEST_SERVER_2_USER=openruyi
TEST_SERVER_2_PASSWORD=openruyi
```

### 5.3 测试用例声明 (`extra-hardware-require`)

#### 支持的字段

| 字段 | 含义 | 检查方式 | 示例值 |
|------|------|----------|--------|
| `server` | 需要的服务器数量 | 对比 `TEST_SERVER_COUNT` | `2` |
| `cpu` | 每台 CPU 核心数 | `nproc` | `">= 4"` |
| `memory` | 每台可用内存 | `free -g` | `">= 8 GiB"` |
| `disk` | 每台磁盘数量 | `lsblk -nd` | `">= 1"` |
| `net` | 每台 UP 状态网卡数 | `ip -o link show` | `">= 1"` |

支持的比较运算符：`=` `!=` `>=` `<=` `>` `<`

#### 层级继承

利用 FMF 的层级继承机制，在测试分类父级统一声明默认值，子套件无需重复：

```
tests/functional/main.fmf          ← extra-hardware-require (默认值)
  └─ pkgs/acl/main.fmf              ← 无 extra-hardware-require → 继承父级
  │    ├─ test_acl_getfacl_basic/    → 获得默认约束 ✅
  │    └─ test_acl_setfacl/          → 获得默认约束 ✅
  └─ kernel/realtime/main.fmf       ← cpu: ">= 16" → 覆盖 cpu
       └─ test_rt_latency/           → cpu>=16, 其余继承默认 ✅
```

#### 当前默认值

所有测试分类父级 `tests/*/main.fmf` 已统一声明：

```yaml
extra-hardware-require:
  server: 1
  cpu: ">= 4"
  memory: ">= 8 GiB"
  disk: ">= 1"
  net: ">= 1"
```

#### 按需覆盖

子套件只需覆盖需要提升的字段，其余自动继承：

```yaml
# tests/functional/kernel/realtime/main.fmf
extra-hardware-require:
  cpu: ">= 16"        # 覆盖父级的 ">= 4"
  memory: ">= 16 GiB"  # 覆盖父级的 ">= 8 GiB"
  # server/disk/net 未写，自动继承父级默认值
```

### 5.4 公共库函数 (`tests/lib/hw_check.sh`)

测试脚本中引入公共库后调用：

```bash
. "$(dirname "$0")/../../lib/hw_check.sh"
```

| 函数 | 用途 |
|------|------|
| `hwVerify [fmf]` | 综合检查所有字段，不满足则 `exit 0`（tmt 视为 skip） |
| `hwServerVerify [fmf]` | 仅检查服务器数量 |
| `hwCpuCheck [fmf]` | 仅检查 CPU 核心数 |
| `hwMemCheck [fmf]` | 仅检查内存大小 |
| `hwDiskCheck [fmf]` | 仅检查磁盘数量 |
| `hwNetCheck [fmf]` | 仅检查网卡数量（UP 状态，排除 lo） |
| `hwRunOnServer <idx> <cmd>` | 在指定索引的服务器上远程执行命令 |
| `hwGetServerInfo <idx> <field>` | 获取服务器连接信息 (`host`/`port`/`user`/`password`) |

### 5.5 Plan 配置

所有 `how: local` 的 Plan 需添加 `environment-file` 以加载拓扑环境变量：

```yaml
# plans/functional.fmf
environment-file:
  - topology.env
```

当前项目所有 Plan 文件已统一配置：`functional`、`smoke`、`security`、`performance`、`reliability`、`compatibility`、`feature`、`all`。

### 5.6 完整用例示例

**`main.fmf`**：

```yaml
summary: 功能测试 - my_pkg - 多机主备切换
test: ./test.sh
tag:
  - functional
  - my_pkg
duration: 5m
tier: 2
extra-hardware-require:
  server: 2
```

**`test.sh`**：

```bash
#!/bin/bash
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../../lib/hw_check.sh"   # ← 引入公共库

rlJournalStart
    rlPhaseStartSetup "环境准备"
        rlRun "dnf install -y my-pkg" 0 "安装 my-pkg"
    rlPhaseEnd

    rlPhaseStartTest "主备切换测试"
        # ⚠️ hwVerify 必须放在 Test Phase 第一行
        #   放在 Setup 中会导致 Cleanup 被跳过（exit 0 绕过 rlJournalEnd）
        hwVerify

        # 本机启动主服务
        rlRun "my-server --start --role=master" 0 "启动主节点"

        # server-2 启动备服务
        hwRunOnServer 2 "my-server --start --role=standby"

        # 从 server-2 连接 server-1 验证
        local s1_host=$(hwGetServerInfo 1 host)
        hwRunOnServer 2 "my-client --connect $s1_host --check-status"
    rlPhaseEnd

    rlPhaseStartCleanup "清理环境"
        rlRun "my-server --stop" 0 "停止主节点"
        hwRunOnServer 2 "my-server --stop"
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
```

### 5.7 工作机制

```
tmt run plan --name /plans/functional
  │
  ├─ environment-file 加载 topology.env → 环境变量就绪
  │
  ├─ discover: 发现所有包含 tag:functional 的测试
  │
  ├─ execute:
  │   ├─ test_acl_basic: 继承默认 extra-hardware-require → hwVerify() 自动检查
  │   ├─ test_multi_host:
  │   │   ├─ hwVerify()
  │   │   │   ├─ TEST_SERVER_COUNT=1, need=2 → "SKIP: need 2 servers"
  │   │   │   └─ exit 0（tmt 记录为 skip）
  │   │   └─ （不满足时不执行后续测试逻辑）
  │   └─ ...
  │
  └─ report: 汇总所有 skip 状态及原因
```

> **设计原则**：利用 FMF 层级继承 + 环境变量注入 + 公共库自检，实现与上层 provision 插件一致的"不满足即跳过"语义，且避免在每个套件重复声明硬件需求。

---

## 6. 命名规范

| 规则 | 示例 |
|------|------|
| 测试用例目录：`test_{包名}_{功能描述}` | `test_acl_getfacl_basic` |
| 全小写，下划线分隔 | `test_coreutils_ls_command` |
| 功能描述用英文 | `test_bash_variable_expansion` |
| 简单检查包：`test_{包名}_basic_check` | `test_attr_basic_check` |
| 无分组包：`test_{包名}_main` | `test_filesystem_main` |

---

## 7. 执行和验证

### 本地验证

```bash
# 执行单个新测试用例
tmt run --all --verbose plan --name /plans/functional \
    test --name /tests/functional/pkgs/acl/test_acl_my_feature \
    provision --feeling-safe

# 查看结果
tmt run --last report -fvvv
```

### 验证清单

- [ ] `main.fmf` 包含所有必填字段（summary, test, tag, duration, tier, path, require）
- [ ] `tag` 包含正确的计划标签（如 `functional`），确保能被 Plan 发现
- [ ] `require` 包含被测包 + `coreutils` + `beakerlib`
- [ ] `test.sh` 首行 `#!/bin/bash`，sources beakerlib 和 lib.sh
- [ ] 手动执行可通过 (`bash test.sh`)
- [ ] 无硬编码路径，使用相对路径和 `$TmpDir`
- [ ] Cleanup 阶段正确清理临时文件，共享库自动管理软件包卸载
- [ ] 如有多机需求，调用 `hwVerify` 进行环境自检（放在 Test Phase 第一行）

---

## 8. 单元测试（代码质量检查）

`unittests/` 目录包含针对测试框架本身的单元测试，确保所有测试用例符合项目规范。提交 PR 前请在本地运行这些测试。

### 8.1 运行单元测试

```bash
# 运行所有单元测试
python -m unittest discover -s unittests -p "test_*.py" -v

# 运行单个测试文件
python -m unittest unittests.test_tests_quality -v
```

### 8.2 测试用例概览

所有测试位于 `unittests/test_tests_quality.py`，目前共 **10 个测试**，分为 5 大类：

| 类别 | 测试 | 描述 |
|------|------|------|
| **中文字符** | `test_no_chinese_in_tests` | 确保 `tests/` 目录下文件不含中文字符 |
| **乱码检测** | `test_no_mojibake_in_tests` | 检测 Latin-1 乱码（如 `ä½ å¥½`） |
| **Shell 脚本规范** | `test_test_sh_compliance` | 验证 `test.sh` 文件符合 BeakerLib 结构（`rlJournalStart`、`rlPhaseStart*`、`rlJournalEnd`、`#!/bin/bash`） |
| | `test_lib_sh_compliance` | 验证 `lib.sh` 文件符合共享库约定（`library-prefix` 注解、`*Setup()` 函数） |
| | `test_no_crlf_in_sh_files` | 确保所有 `.sh` 文件使用 LF 换行符，不含 CRLF |
| | `test_main_fmf_yaml_valid` | 验证 `main.fmf` 文件是合法的 YAML 且包含必填字段 |
| **可执行权限** | `test_sh_files_executable_in_git` | 确保 `.sh` 文件在 git 中具有可执行权限（`100755`） |
| | `test_no_non_sh_executable_in_tests` | 确保 `tests/` 下非 `.sh` 文件没有可执行权限 |
| **缩进规范** | `test_no_tab_in_sh` | 确保 `.sh` 文件中没有 Tab 字符 |
| | `test_sh_indentation_multiple_of_4` | 确保缩进为 4 的倍数（每层嵌套 4 空格） |

### 8.3 关键设计说明

- **基于 Git 的检查**：大多数测试通过 `git show` 读取已提交内容，避免 `core.autocrlf=true` 的换行符转换干扰。
- **Heredoc 感知**：缩进测试会排除 heredoc 体内容（`<<WORD ... WORD`），避免嵌入式代码（C、Makefile 等）产生误报。
- **提交 PR 前确保 10 个测试全部通过**。

---

## 9. 常见问题

### Q: test.sh 需要可执行权限吗？

tmt 通过 `bash test.sh` 执行，不强制要求，但建议 `chmod +x`。

### Q: 如何复用其他测试的安装逻辑？

使用 `lib.sh` 共享库 + 引用计数机制（参见 3.4 节）。

### Q: 我写了 main.fmf 但 tmt 执行时提示 0 tests discovered？

1. 确认 `tag` 字段与 Plan 的 `filter` 匹配（如 `filter: "tag:functional"`）
2. 确认 `main.fmf` 文件在正确路径下
3. 运行 `tmt test ls` 查看 tmt 发现了哪些测试：
   ```bash
   cd openruyi-autotest
   tmt test ls | grep <your_test_name>
   ```

### Q: rlRun 执行失败但命令本身是正确的？

可能是 rlRun 的 `expect` 参数不匹配。rlRun 第二个参数是期望退出码：
- `rlRun "cmd" 0`：期望命令成功（退出码 0）
- `rlRun "cmd should fail" 1`：期望命令失败（退出码 1）
- 如果实际退出码与期望不符，rlRun 报告失败

### Q: hwVerify 放在 Setup 还是 Test 阶段？

**必须在 Test Phase 第一行**。`hwVerify` 不满足时会 `exit 0`，如果放在 Setup 阶段，`exit 0` 会绕过 `rlJournalEnd`，导致 Cleanup 不执行、临时文件残留。

### Q: 如何调试失败的测试？

```bash
# 查看完整输出
cat /var/tmp/tmt/run-*/plans/functional/execute/data/guest/default-0/tests/.../output.txt

# 手动执行脚本（可直接调试）
bash tests/functional/pkgs/acl/test_acl_my_feature/test.sh
```

---

## 10. 实战示例：开发 ACL 测试套

本节完整演示如何从零开始为一个新的软件包开发测试套，以 `acl` 为例。

### 10.1 总体流程

```
需求分析 → 创建套件目录 → 编写 lib.sh → 编写 main.fmf → 编写 test.sh → 验证执行
```

ACL 测试套共 **11 个测试用例**，覆盖 getfacl、setfacl、chacl 三大命令的所有主要功能点。

### 10.2 第 1 步：创建套件目录结构

```bash
# 创建软件包级目录
mkdir -p tests/functional/pkgs/acl

# 创建包级元数据
cat > tests/functional/pkgs/acl/main.fmf << 'EOF'
summary: 功能测试 - acl 软件包功能验证
tag:
  - functional
  - acl
duration: 5m
tier: 1
path: /tests/functional/pkgs/acl
require:
  - acl
  - coreutils
  - beakerlib
EOF
```

### 10.3 第 2 步：编写共享库 `lib.sh`

11 个测试用例都需要 `acl` 软件包，使用共享库 + 引用计数避免每个用例重复安装/卸载：

```bash
cat > tests/functional/pkgs/acl/lib.sh << 'EOF'
# library-prefix = acl
#
# ACL suite-level shared library
# Uses flag-file + reference counting to ensure the acl package
# is installed only ONCE and uninstalled only ONCE across all
# test cases.

ACL_FLAG="/tmp/.beakerlib_acl_suite"

aclSetup() {
    if [ ! -f "$ACL_FLAG" ]; then
        if ! rpm -q acl 2>/dev/null; then
            echo openruyi | sudo -S dnf install -y acl 2>/dev/null
            echo "installed=1" > "$ACL_FLAG"
            rlLogInfo "已安装 acl 软件包（首次）"
        else
            echo "installed=0" > "$ACL_FLAG"
            rlLogInfo "acl 软件包已存在"
        fi
        echo "ref=1" >> "$ACL_FLAG"
    else
        local ref=$(grep "^ref=" "$ACL_FLAG" | cut -d= -f2)
        ref=$((ref + 1))
        sed -i "s/^ref=.*/ref=$ref/" "$ACL_FLAG"
        rlLogInfo "acl 已由其他测试安装，引用计数: $ref"
    fi
    rlCleanupAppend "aclCleanup"
}

aclCleanup() {
    if [ ! -f "$ACL_FLAG" ]; then
        return 0
    fi
    local ref=$(grep "^ref=" "$ACL_FLAG" | cut -d= -f2)
    ref=$((ref - 1))
    if [ "$ref" -le 0 ]; then
        if grep -q "^installed=1" "$ACL_FLAG"; then
            echo openruyi | sudo -S dnf remove -y acl 2>/dev/null || true
            rlLogInfo "已卸载 acl 软件包（最后一个测试）"
        fi
        rm -f "$ACL_FLAG"
    else
        sed -i "s/^ref=.*/ref=$ref/" "$ACL_FLAG"
        rlLogInfo "acl 保留（还有 $ref 个测试未完成）"
    fi
}
EOF
```

### 10.4 第 3 步：逐功能点开发测试用例

以下按功能点分别创建目录、main.fmf 和 test.sh。

#### 9.4.1 用例 1: getfacl 基本功能

```bash
mkdir -p tests/functional/pkgs/acl/test_acl_getfacl_basic
```

**`main.fmf`**：

```yaml
summary: 功能测试 - acl - getfacl 基本功能
test: ./test.sh
tag:
  - functional
  - acl
duration: 2m
tier: 1
path: /tests/functional/pkgs/acl/test_acl_getfacl_basic
require:
  - acl
  - beakerlib
```

**`test.sh`** — 覆盖 7 个功能点，每个功能点至少一个 `rlRun`：

```bash
#!/bin/bash
# Functional test: acl - getfacl basic
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        aclSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
        rlRun "touch testfile" 0 "创建测试文件"
        rlRun "mkdir testdir" 0 "创建测试目录"
    rlPhaseEnd

    rlPhaseStartTest "getfacl 基本功能"
        # 功能点 1: 查看文件默认 ACL（含基本权限条目）
        rlRun "getfacl testfile 2>&1 | grep -qE \"user::|group::|other::\"" 0 \
            "查看文件默认 ACL 含权限条目"

        # 功能点 2: 查看目录默认 ACL
        rlRun "getfacl testdir 2>&1 | grep -qE \"user::|group::|other::\"" 0 \
            "查看目录默认 ACL 含权限条目"

        # 功能点 3: -a 参数只显示 access ACL
        rlRun "getfacl -a testfile 2>&1 | grep -qE \"user::|group::\"" 0 \
            "使用 -a 参数查看 access ACL"

        # 功能点 4: -d 参数只显示 default ACL
        rlRun "getfacl -d testfile 2>&1 | grep -qE \"user::|default\"" 0 \
            "使用 -d 参数查看 default ACL 含 default 条目"

        # 功能点 5: -c 参数不显示注释头
        rlRun "getfacl -c testfile 2>&1" 0 "使用 -c 参数不显示注释头"
        rlAssertNotGrep "^# file:" "$(getfacl -c testfile 2>&1)" \
            "-c 输出不包含注释头"

        # 功能点 6: -n 参数显示数字用户/组 ID
        rlRun "getfacl -n testfile 2>&1 | grep -qE \"[0-9]+\"" 0 \
            "使用 -n 参数显示数字 ID"

        # 功能点 7: -t 参数使用表格输出格式
        rlRun "getfacl -t testfile 2>&1 | grep -qE \"[r-][w-][x-]\"" 0 \
            "使用 -t 参数表格输出含权限位"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
```

#### 9.4.2 用例 2: setfacl 基本功能

```bash
mkdir -p tests/functional/pkgs/acl/test_acl_setfacl_basic
```

**`test.sh`** — 侧重 setfacl 的基础增删改查：

```bash
#!/bin/bash
# Functional test: acl - setfacl basic
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        aclSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
        rlRun "touch testfile" 0 "创建测试文件"
        rlRun "mkdir testdir" 0 "创建测试目录"
    rlPhaseEnd

    rlPhaseStartTest "setfacl 基本功能"
        # 功能点 1: -m 设置 user ACL
        rlRun "setfacl -m u:root:rwx testfile" 0 "设置用户 ACL"
        rlRun "getfacl testfile 2>&1 | grep -q 'user:root:rwx'" 0 "确认 user ACL 已设置"

        # 功能点 2: -m 设置 group ACL
        rlRun "setfacl -m g:root:r-- testfile" 0 "设置用户组 ACL"

        # 功能点 3: -m 设置 mask
        rlRun "setfacl -m m::rwx testfile" 0 "设置 mask"
        rlRun "getfacl testfile 2>&1 | grep -q 'mask::rwx'" 0 "确认 mask 已设置"

        # 功能点 4: -x 删除指定 ACL
        rlRun "setfacl -x g:root testfile" 0 "删除组 ACL 条目"
        rlRun "! getfacl testfile 2>&1 | grep -q 'group:root:'" 0 "确认组 ACL 已删除"

        # 功能点 5: -b 删除所有扩展 ACL
        rlRun "setfacl -b testfile" 0 "删除所有扩展 ACL"
        rlRun "! getfacl testfile 2>&1 | grep -qE '(user:|group:)(?!:[:space:]|::)'" 0 \
            "确认所有命名 ACL 已清除"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
```

#### 9.4.3 用例 3: 错误处理

```bash
mkdir -p tests/functional/pkgs/acl/test_acl_error_handling
```

**`test.sh`** — 使用 `rlRun` 的 `expect=1` 模式验证错误路径：

```bash
#!/bin/bash
# Functional test: acl - error handling
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        aclSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
        rlRun "touch testfile" 0 "创建测试文件"
    rlPhaseEnd

    rlPhaseStartTest "错误处理"
        # 功能点 1: 不存在的文件 — 期望失败 (exit 1)
        rlRun "getfacl /nonexistent 2>&1 | grep -qiE \"error|Error|No such|无法|not found\" || echo expected-error" 1 \
            "查看不存在的文件"

        # 功能点 2: 不存在的用户 — 期望失败
        rlRun "setfacl -m u:nobody_xxx:rwx testfile 2>&1 | grep -qiE \"error|Error|Invalid|无效\" || echo expected-error" 1 \
            "设置不存在的用户"

        # 功能点 3: 无效权限 — 期望失败
        rlRun "setfacl -m u:root:abc testfile 2>&1 | grep -qiE \"error|Error|Invalid|无效\" || echo expected-error" 1 \
            "设置无效权限字符串"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
```

### 10.5 第 4 步：本地验证

```bash
cd ~/openruyi-autotest

# 1. 确认 tmt 能发现新测试
tmt test ls | grep acl

# 预期输出:
# /tests/functional/pkgs/acl/test_acl_getfacl_basic
# /tests/functional/pkgs/acl/test_acl_setfacl_basic
# /tests/functional/pkgs/acl/test_acl_error_handling

# 2. 先手动执行验证语法
bash tests/functional/pkgs/acl/test_acl_getfacl_basic/test.sh

# 3. 通过 tmt 执行
tmt run --all plan --name /plans/functional \
    test --name /tests/functional/pkgs/acl \
    provision --feeling-safe

# 4. 查看汇总结果
tmt run --last report
```

### 10.6 ACL 测试套完整清单

| # | 用例 | 功能点 | 覆盖命令 |
|---|------|--------|----------|
| 1 | `test_acl_acl_inheritance` | 默认 ACL 继承、目录下新建文件继承 | getfacl |
| 2 | `test_acl_acl_permission_verify` | ACL 权限实际生效（读/写/执行） | setfacl, getfacl |
| 3 | `test_acl_chacl_command` | chacl 命令基本操作 | chacl |
| 4 | `test_acl_error_handling` | 不存在的文件/用户、无效权限 | getfacl, setfacl |
| 5 | `test_acl_getfacl_basic` | 7 个 getfacl 参数 (-a/-d/-c/-n/-t) | getfacl |
| 6 | `test_acl_setfacl_advanced` | default ACL、--set、-M 从文件读取 | setfacl |
| 7 | `test_acl_setfacl_basic` | -m/-x/-b 增删改查 | setfacl |
| 8 | `test_acl_setfacl_recursive` | -R 递归设置 | setfacl |
| 9 | `test_acl_setfacl_remove` | -x 按条目删除、-X 文件批量删除 | setfacl |
| 10 | `test_acl_setfacl_symlink` | -L/-P 符号链接处理 | setfacl |
| 11 | `test_acl_special_cases` | 多用户多组、--test 试运行、备份恢复 | setfacl, getfacl |

> **关键设计决策**：每个用例只测试一个明确的主题（如 "getfacl 基本功能"），避免一个巨长脚本涵盖所有功能。这样单独执行/调试更方便，tmt 报告也更精确。

### 10.7 开发检查清单

对照第 7 节的验证清单，逐项确认：

- [x] 每个 `main.fmf` 包含 summary, test, tag, duration, tier, path, require
- [x] `tag` 包含 `functional` (Plan filter) 和 `acl` (软件包标签)
- [x] `require` 包含 `acl` + `coreutils` + `beakerlib`
- [x] 每个 `test.sh` 首行 `#!/bin/bash`，sources beakerlib.sh 和 ../lib.sh
- [x] Setup: 调用 `aclSetup` → 创建 `$TmpDir` → `cd $TmpDir`
- [x] Test: 每个功能点至少一个 `rlRun` 或 `rlAssertGrep`
- [x] Cleanup: `cd /` → `rm -rf $TmpDir` → 共享库自动卸载
- [x] 错误路径用例使用 `rlRun "cmd" 1`（期望失败）
- [x] 所有用例独立可运行（依赖共享库但不需要其他用例的输出）
