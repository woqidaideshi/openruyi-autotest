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

当测试用例对服务器数量、CPU、内存、磁盘或网卡有特殊要求时，通过 Plan 的 `provision` 步骤声明硬件需求。tmt 提供一套通用的 `hardware` 键来描述约束，参见 [tmt Hardware 官方规范](https://tmt.readthedocs.io/en/stable/spec/hardware.html)。

### 5.1 核心概念

| 概念 | 说明 |
|------|------|
| **`hardware` 键** | 在 `provision` 下声明，描述对 guest（测试机）的硬件需求 |
| **`multihost`** | 在 `provision` 下定义多个节点，每个节点有独立的角色和硬件需求 |
| **比较运算符** | `=` `!=` `>` `>=` `<` `<=`（数值）；`=` `!=` `~` `!~`（字符串） |
| **逻辑运算符** | `and` / `or` 组合多重约束 |
| **单位** | 基于 [pint](https://pint.readthedocs.io/) 库，支持十进制 (MB/GB) 和二进制 (MiB/GiB) 前缀 |

### 5.2 单一节点硬件约束

在 Plan 的 `provision` 步骤下使用 `hardware` 键：

```yaml
provision:
    how: virtual              # 或其他 provision 插件
    image: fedora
    hardware:
        cpu:
            processors: ">= 16"    # 至少 16 个逻辑 CPU
            cores: ">= 8"          # 至少 8 个物理核心
        memory: ">= 32 GiB"        # 至少 32 GiB 内存
        disk:
          - size: ">= 100 GB"      # 第一块磁盘 ≥ 100 GB
          - size: ">= 500 GB"      # 第二块磁盘 ≥ 500 GB
```

#### 5.2.1 CPU 约束

```yaml
hardware:
    cpu:
        processors: ">= 16"           # 逻辑 CPU 数量（lscpu 看到的 "CPU(s)"）
        cores: ">= 8"                 # 物理核心数
        cores-per-socket: 4           # 每路核心数
        threads-per-core: 2           # 每核线程数
        hyper-threading: true         # 是否开启超线程
        model-name: "~ Intel.*"       # CPU 型号名（支持正则）
        family: 6                     # CPU family
        flag:                         # 需要特定 CPU 特性
          - avx
          - avx2
```

| 字段 | 类型 | 说明 |
|------|------|------|
| `processors` | int / string | 逻辑 CPU 总数（与操作系统看到的 "CPU(s)" 一致） |
| `cores` | int / string | 物理 CPU 核心数 |
| `sockets` | int / string | CPU 插槽数 |
| `threads` | int / string | CPU 线程数 |
| `cores-per-socket` | int / string | 每个插槽的核心数 |
| `threads-per-core` | int / string | 每个核心的线程数 |
| `hyper-threading` | bool | 是否需要超线程 |
| `family` | int / string | CPU family 编号 |
| `model` | int / string | CPU model 编号 |
| `model-name` | string | CPU 型号名称（支持 `~` 正则） |
| `vendor-name` | string | CPU 厂商名，如 `GenuineIntel` |
| `flag` | list | 要求 CPU 支持的 flag 列表（隐式 and） |

#### 5.2.2 内存约束

```yaml
hardware:
    memory: ">= 16 GiB"         # 至少 16 GiB 内存
    # 等效写法: memory: ">= 16 GB"
    # 不需单位时默认 MiB: memory: ">= 16384"
```

支持的运算符：`=` `!=` `>=` `<=` `>` `<`

#### 5.2.3 磁盘约束

`disk` 是**列表**，每个元素代表**一块独立磁盘**：

```yaml
hardware:
    disk:
      - size: ">= 40 GB"              # 第 1 块：系统盘 ≥ 40 GB
      - size: ">= 500 GB"             # 第 2 块：数据盘 ≥ 500 GB
        model-name: 'PERC H310'       # 特定磁盘型号
        driver: megaraid_sas          # 特定驱动
      - size: ">= 1 TB"               # 第 3 块：大容量存储
        driver: "~ sas.*"             # 要求 SAS 驱动（正则）
```

| 字段 | 类型 | 说明 |
|------|------|------|
| `size` | string | 磁盘容量，默认单位 Byte |
| `model-name` | string | 磁盘型号名称 |
| `driver` | string | 内核驱动模块名 |
| `logical-sector-size` | string | 逻辑扇区大小 |
| `physical-sector-size` | string | 物理扇区大小 |

#### 5.2.4 网络设备约束

```yaml
hardware:
    network:
      - type: eth                    # 第一张网卡：以太网
      - type: eth                    # 第二张网卡：以太网
        vendor-name: "~ ^Broadcom"   # 指定厂商（正则）
      - type: eth                    # 第三张网卡
```

`network` 同样是列表，每个元素代表一张网卡。用列表长度来控制网卡数量。

| 字段 | 类型 | 说明 |
|------|------|------|
| `type` | string | 网络设备类型（如 `eth`、`bridge`） |
| `device-name` | string | 设备名称 |
| `vendor-name` | string | 厂商名称 |
| `driver` | string | 驱动模块名 |

#### 5.2.5 高级：逻辑组合

```yaml
hardware:
    and:                          # 所有条件必须同时满足
      - cpu:
            family: 15
      - or:                       # 以下任一条件满足即可
          - cpu:
                model: 65
          - cpu:
                model: 67
      - memory: ">= 16 GiB"
```

> **注意**：`and` / `or` 不能与普通 `key: value` 混合在同一层级。如需组合，将所有约束放入 `and` 下。

### 5.3 多机（Multihost）约束

当测试需要**多台服务器**协同工作时（如 C/S 架构、主备切换、分布式测试），在 `provision` 下定义**多个节点**：

```yaml
provision:
  - name: server                   # 节点 1：服务器
    role: primary                  # 角色标签
    how: virtual
    image: fedora
    hardware:
        cpu:
            processors: ">= 8"
        memory: ">= 16 GB"
        disk:
          - size: ">= 40 GB"

  - name: client-1                 # 节点 2：客户端 1
    role: client
    how: virtual
    hardware:
        cpu:
            processors: ">= 4"
        memory: ">= 8 GiB"

  - name: client-2                 # 节点 3：客户端 2
    role: client                   # 可与 client-1 共享角色
    how: virtual
```

#### 5.3.1 关键字段

| 字段 | 说明 |
|------|------|
| `name` | 节点唯一标识，区分不同 guest |
| `role` | 节点角色，用于 `where` 定向执行和拓扑暴露 |
| `where` | 在 prepare/discover/execute 步骤中指定仅在特定角色/节点上运行 |

#### 5.3.2 按角色定向执行

```yaml
prepare:
  - how: shell
    name: setup-server
    script: |
        dnf install -y httpd
        systemctl start httpd
    where: primary                 # 仅在 primary 角色上执行

  - how: shell
    name: setup-client
    script: dnf install -y curl
    where: client                  # 在所有 client 角色上执行

discover:
  - how: fmf
    filter: tag:server-tests
    where: primary                 # Server 测试只在 primary 上收集

  - how: fmf
    filter: tag:client-tests
    where: client                  # Client 测试只在 client 上收集
```

#### 5.3.3 拓扑信息暴露

tmt 自动将多机拓扑信息注入环境变量，测试脚本可按需读取：

| 环境变量 | 说明 |
|----------|------|
| `TMT_TOPOLOGY_YAML` | 完整拓扑信息（YAML 格式）路径 |
| `TMT_TOPOLOGY_BASH` | 可 source 的拓扑信息（bash 格式）路径 |
| `TMT_GUEST_NAME` | 当前 guest 的名称 |
| `TMT_GUEST_ROLE` | 当前 guest 的角色 |
| `TMT_GUEST_HOSTNAME` | 当前 guest 的主机名 |

在测试脚本中使用：

```bash
# 读取拓扑信息
. "$TMT_TOPOLOGY_BASH"

# 获取所有 guest 名称（空格分隔）
echo "All guests: $TMT_GUEST_NAMES"

# 获取每个角色的 guest 列表
echo "Primary nodes: ${TMT_ROLES[primary]}"
echo "Client nodes:  ${TMT_ROLES[client]}"

# 获取特定 guest 的属性
for guest in $TMT_GUEST_NAMES; do
    echo "  $guest: role=${TMT_GUEST_${guest}[role]}, hostname=${TMT_GUEST_${guest}[hostname]}"
done
```

### 5.4 Provision 插件支持矩阵

不同 provision 插件对 `hardware` 的支持程度不同，实际使用时需选择适合的插件：

| 需求 | artemis | beaker | virtual.testcloud | container / local / connect |
|------|:-------:|:------:|:-----------------:|:---------------------------:|
| `cpu.processors` | ✅ | ✅ | ✅ | ❌ |
| `cpu.cores` | ✅ | ✅ | ❌ | ❌ |
| `cpu.model-name` | ✅ | ✅ | ❌ | ❌ |
| `memory` | ✅ | ✅ | ✅ (仅 `=` `>=` `<=`) | ❌ |
| `disk.size` | ✅ | ✅ | ✅ (仅 `=` `>=` `<=`) | ❌ |
| `disk.model-name` | ✅ | ✅ | ❌ | ❌ |
| `network` | ✅ (仅 `eth`) | ❌ | ❌ | ❌ |
| `boot.method` | ✅ | ❌ | ✅ | ❌ |
| Multihost | ✅ | ✅ | ✅ | ✅ |

> **建议**：对于不需要特殊硬件的测试用例，使用默认的 `how: local` 即可。当需要精确控制硬件环境时，优先选择 `virtual.testcloud`（本地虚拟化）或 `artemis`（云端资源池）。

### 5.5 完整示例

#### 单节点 16 核 + 64G 内存 + 双磁盘

```yaml
# plans/performance.fmf
summary: 性能测试 - 需要高规格硬件
discover:
  how: fmf
  test:
    - /tests/performance
provision:
  how: virtual
  image: fedora
  hardware:
    cpu:
        processors: ">= 16"
        cores: ">= 8"
    memory: ">= 64 GiB"
    disk:
      - size: ">= 100 GB"
      - size: ">= 1 TB"
prepare:
  - how: shell
    script: dnf install -y fio
execute:
  how: tmt
```

#### 多机主备切换测试

```yaml
# plans/reliability.fmf
summary: 可靠性测试 - 主备切换
discover:
  how: fmf
  test:
    - /tests/reliability
provision:
  - name: primary-node
    role: master
    how: virtual
    hardware:
        cpu:
            processors: ">= 4"
        memory: ">= 8 GB"

  - name: backup-node
    role: standby
    how: virtual
    hardware:
        cpu:
            processors: ">= 4"
        memory: ">= 8 GB"

prepare:
  - how: shell
    where: master
    script: |
        dnf install -y keepalived
        systemctl start keepalived
  - how: shell
    where: standby
    script: |
        dnf install -y keepalived
        systemctl start keepalived

execute:
  how: tmt
```

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
