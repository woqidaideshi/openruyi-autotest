# openruyi-autotest 开发指南

> 如何为 openruyi-autotest 贡献新的测试用例。

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
tag:
  - functional
  - acl
duration: 2m
tier: 1
path: /tests/functional/pkgs/acl/test_acl_my_feature
require:
  - acl
  - beakerlib
EOF
```

### 3.2 编写测试脚本

```bash
cat > tests/functional/pkgs/acl/test_acl_my_feature/test.sh << 'TESTEOF'
#!/bin/bash
# Functional test: acl - my feature
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        aclSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
        rlRun "touch testfile" 0 "创建测试文件"
    rlPhaseEnd

    rlPhaseStartTest "我的功能测试"
        # 功能点 1: 基本验证
        rlRun "getfacl testfile" 0 "查看文件默认 ACL"

        # 功能点 2: 设置 ACL
        rlRun "setfacl -m u:root:rwx testfile" 0 "设置用户 ACL"
        rlAssertGrep "user:root:rwx" "$(getfacl testfile 2>&1)" "确认 ACL 已设置"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
TESTEOF
```

### 3.3 BeakerLib 生命周期

每个测试脚本遵循标准的三阶段结构：

| 阶段 | 函数 | 用途 |
|------|------|------|
| **Setup** | `rlPhaseStartSetup` | 环境准备：安装软件包、创建临时目录 |
| **Test** | `rlPhaseStartTest` | 执行测试：调用被测试命令、断言结果 |
| **Cleanup** | `rlPhaseStartCleanup` | 清理环境：删除临时文件、卸载软件包 |

### 3.4 共享库（lib.sh）

当同一个软件包下多个测试用例需要共享安装/卸载逻辑时，使用 `lib.sh`：

```bash
# lib.sh 示例 — 引用计数机制确保软件包只安装/卸载一次
PKG_FLAG="/tmp/.beakerlib_my_pkg_suite"

myPkgSetup() {
    if [ ! -f "$PKG_FLAG" ]; then
        if ! rpm -q my-pkg 2>/dev/null; then
            sudo dnf install -y my-pkg 2>/dev/null
            echo "installed=1" > "$PKG_FLAG"
        else
            echo "installed=0" > "$PKG_FLAG"
        fi
        echo "ref=1" >> "$PKG_FLAG"
    else
        local ref=$(grep "^ref=" "$PKG_FLAG" | cut -d= -f2)
        ref=$((ref + 1))
        sed -i "s/^ref=.*/ref=$ref/" "$PKG_FLAG"
    fi
    rlCleanupAppend "myPkgCleanup"
}

myPkgCleanup() {
    [ ! -f "$PKG_FLAG" ] && return 0
    local ref=$(grep "^ref=" "$PKG_FLAG" | cut -d= -f2)
    ref=$((ref - 1))
    if [ "$ref" -le 0 ]; then
        grep -q "^installed=1" "$PKG_FLAG" && sudo dnf remove -y my-pkg 2>/dev/null || true
        rm -f "$PKG_FLAG"
    else
        sed -i "s/^ref=.*/ref=$ref/" "$PKG_FLAG"
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
| `tag` | list | ✅ | 标签列表，如 `[functional, acl]` |
| `duration` | string | ✅ | 预估执行时间，如 `2m`、`5m` |
| `tier` | int | ✅ | 优先级：0=核心，1=功能，2=扩展 |
| `path` | string | ✅ | 测试路径，格式 `/tests/<type>/pkgs/<pkg>/<test>` |
| `require` | list | ✅ | 依赖的 RPM 软件包 |
| `contact` | string | | 测试负责人 |
| `environment` | dict | | 环境变量 |

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
| 测试用例声明 | `main.fmf` 中的 `hardware-require` | 每个用例声明自己的硬件需求 |
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

### 5.3 测试用例声明 (`hardware-require`)

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
tests/functional/main.fmf          ← hardware-require (默认值)
  └─ pkgs/acl/main.fmf              ← 无 hardware-require → 继承父级
  │    ├─ test_acl_getfacl_basic/    → 获得默认约束 ✅
  │    └─ test_acl_setfacl/          → 获得默认约束 ✅
  └─ kernel/realtime/main.fmf       ← cpu: ">= 16" → 覆盖 cpu
       └─ test_rt_latency/           → cpu>=16, 其余继承默认 ✅
```

#### 当前默认值

所有测试分类父级 `tests/*/main.fmf` 已统一声明：

```yaml
hardware-require:
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
hardware-require:
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
hardware-require:
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
        # 环境自检，不满足自动 SKIP
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
  │   ├─ test_acl_basic: 继承默认 hardware-require → hwVerify() 自动检查
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

- [ ] `main.fmf` 包含所有必填字段
- [ ] `test.sh` 有可执行权限 (`chmod +x`)
- [ ] 本地执行通过
- [ ] 无硬编码路径，使用相对路径和 `$TmpDir`
- [ ] Cleanup 阶段正确清理临时文件

---

## 8. 常见问题

### Q: test.sh 需要可执行权限吗？

tmt 通过 `bash test.sh` 执行，不强制要求，但建议 `chmod +x`。

### Q: 如何复用其他测试的安装逻辑？

使用 `lib.sh` 共享库 + 引用计数机制（参见 3.4 节）。

### Q: 如何调试失败的测试？

```bash
# 查看完整输出
cat /var/tmp/tmt/run-*/plan/execute/data/tests/.../output.txt

# 手动执行脚本
bash tests/functional/pkgs/acl/test_acl_my_feature/test.sh
```
