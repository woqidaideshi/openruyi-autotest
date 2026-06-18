# openruyi-autotest

基于 [tmt (Test Management Tool)](https://docs.fedoraproject.org/en-US/ci/tmt/) 的自动化测试框架。

## 目录结构

```
openruyi-autotest/
├── .fmf/                        # FMF 元数据根目录（必须提交到 Git）
│   └── version                  # FMF 版本号
├── plans/                       # 测试计划
│   ├── smoke.fmf                 # 冒烟测试计划
│   ├── functional.fmf            # 功能测试计划
│   ├── security.fmf              # 安全测试计划
│   ├── compatibility.fmf         # 兼容性测试计划
│   ├── performance.fmf           # 性能测试计划
│   ├── reliability.fmf           # 可靠性测试计划
│   ├── integration.fmf           # 集成测试计划
│   └── all.fmf                   # 全量测试计划
├── tests/                       # 测试用例
│   ├── main.fmf                  # 共享配置（子目录自动继承）
│   ├── smoke/                    # 冒烟测试
│   ├── functional/               # 功能测试
│   │   ├── main.fmf               # 共享配置
│   │   ├── README.md
│   │   └── pkgs/                  # RPM 软件包功能测试（202 个包）
│   ├── security/                 # 安全测试
│   ├── compatibility/            # 兼容性测试
│   ├── performance/              # 性能测试
│   └── reliability/              # 可靠性测试
├── stories/                     # 用户故事
│   └── init.fmf
└── README.md
```

## 测试覆盖

### 全量用例统计

| 测试类型 | 测试套数 | 用例数 | 状态 |
|---------|:---:|:---:|:---:|
| Smoke | 17 | 100 | ✅ 全部通过 |
| Functional | 202 | 561 | ✅ 全部通过 |
| Security | 2 | 106 | ✅ 全部通过 (74P/24S/0F CVE) |
| Compatibility | 1 | 10 | ✅ 通过 (569P/36F/21S) |
| Performance | 1 | 5 | ⏳ 待验证 |
| Reliability | 1 | 5 | ⏳ 待验证 |
| **合计** | **224** | **787** | |

### 详情文档

- [冒烟测试覆盖详情](docs/smoke-coverage.md) — 17 个类别，100 个用例
- [功能测试覆盖详情](docs/functional-coverage.md) — 202 个软件包，561 个用例，1,692 个功能点
- [安全测试覆盖详情](docs/security-coverage.md) — 2 个套件（nmap + CVE），106 个用例
- [兼容性测试覆盖详情](docs/compatibility-coverage.md) — 1 个套件（ltp_posix），10 个分类，188 个接口，sudo 验证通过

### 主要覆盖分类

| 分类 | 代表性软件包 | 覆盖要点 |
|------|--------|---------|
| **编译工具** | gcc, g++ (gxx), clang, cmake, make, binutils, autoconf, automake, bison, flex, meson, ninja | C/C++ 编译、链接、优化选项、标准支持 |
| **系统管理** | systemd, systemd-timesyncd, dbus, dbus-broker, chkconfig, kmod, util-linux | 服务管理、日志查询、性能分析、时间同步 |
| **文件/文本工具** | coreutils, tar, grep, sed, gawk, diffutils, findutils, file, gzip, xz, zstd, bzip2, lz4, unzip, cpio, dos2unix | 文件操作、归档、搜索、文本处理 |
| **安全/加密** | openssl, gnutls, libgcrypt, nettle, libtasn1, p11-kit, cryptsetup, pam, libselinux, libseccomp, audit, keyutils, krb5 | 加密算法、TLS、ACL、审计、认证 |
| **网络工具** | iputils, curl, wget, wget2, iproute2, iptables, libpcap, libnl, nghttp2, libssh, libidn2, libpsl | 网络诊断、文件下载、流量控制 |
| **容器/虚拟化** | podman, podmansh | 镜像管理、容器运行、网络配置 |
| **SSH 工具** | openssh, openssh-clients | 密钥生成、SSH 连接、scp/sftp |
| **版本控制** | git | 仓库初始化、分支操作、远程管理 |
| **脚本/编程语言** | python, perl, lua, tcl, bash, tcsh, expect, swig | 解释器、模块、脚本执行 |
| **库/运行时** | glibc, glib, libffi, libxml2, libxslt, libpng, pcre2, expat, icu4c, libarchive, boost, json-c, sqlite, popt, readline, slang, newt, gmp, mpfr, mpc, mpdecimal, isl, libunistring, libxcrypt, libeconf, libcap, libaio, libbpf, libedit, libevent, libmnl, libnfnetlink, libnetfilter_conntrack, libnftnl, libpwquality, libtirpc, libsodium, nghttp2, libmicrohttpd, xxhash, jitterentropy, libgpg-error, libpsl, publicsuffix-list, iso-codes, brotli, lz4, zstd | 动态库验证、头文件、pkg-config |
| **构建/打包工具** | rpmbuild, rpm, pkgconf, debugedit, dwz, chrpath, patch, pyproject-rpm-macros, python-rpm-macros, python-srpm-macros, python-rpm-generators, perl-rpm-packaging, rpm-config-openruyi, setup, filesystem, config | RPM 包构建、调试信息、宏配置 |
| **显示/桌面** | sddm, weston, labwc, groff, texinfo, help2man, scdoc, xmlto, source-highlight | 显示管理器、Wayland 合成器、文档生成 |
| **测试框架** | atf, cmocka, dejagnu, kyua, lutok, beakerlib | 测试库、测试框架 |
| **其他系统工具** | tmux, cloud-utils-growpart, procps-ng, psmisc, vim, less, bc, time, which, ed, fdupes, lzip, rsync, nfs-utils, cracklib, e2fsprogs, gdb, gdbm, gpm, kbd, lvm2, ncurses, nss, nss_wrapper, pam_wrapper, socket_wrapper, uid_wrapper, perl-Error, perl-Locale-gettext, systemtap, tzdata, unbound, ca-certificates, ca-certificates-mozilla, openruyi-release, linux-headers, pciutils, attr, acl, bash-completion, authselect, cpio, cryptsetup, dbus, dbus-broker, diffutils, elfutils, file, findutils, gawk, git, nghttp2, python-flit-core, python-lxml, python-packaging, python-pip, python-pyelftools, python-setuptools, python-wheel, re2c, scdoc, source-highlight, swig, uid_wrapper, xmlto, xxhash | 终端复用、分区扩容、进程管理、编辑器、时间日期 |

### 测试脚本模式

每个测试套件遵循统一的 Shell 测试模式：

```bash
#!/bin/sh -eux
rlRun() { eval "$1" 2>&1; return $?; }

rlRun 'rpm -q <package>' 0 "Check package installed"
# ... 命令覆盖测试 ...
echo "All <package> functional tests passed!"
```

### 在服务器上批量运行

```bash
# 上传所有测试脚本到服务器
# 使用 nohup 后台运行，避免 SSH 断开
for pkg in */; do
    nohup timeout 300 bash ${pkg}test.sh > ${pkg}result.log 2>&1 &
done
```

### 环境要求

- **测试运行器**（执行 tmt 命令的机器）：Fedora 32+ / CentOS 8+ / RHEL 8+ / openEuler 24.03+
- **被测系统**：Fedora / CentOS 6+ / RHEL 6+ / openEuler

### 安装 tmt

#### 常规安装（x86_64/aarch64）

```bash
# 基础安装（仅支持本地执行）
sudo dnf install -y tmt

# 完整安装（支持容器、虚拟机等所有功能）
sudo dnf install -y tmt+all

# 按需安装
sudo dnf install -y tmt+provision-container   # 容器执行
sudo dnf install -y tmt+provision-virtual     # 虚拟机执行
```

也可通过 pip 安装：

```bash
pip3 install tmt
```

#### riscv64 架构安装

在 riscv64 架构（如 openRuyi）上安装 tmt 需要额外的准备步骤，因为某些 Python 包需要从源码编译。

**步骤 1：安装编译工具和依赖**

```bash
# 安装 NFS 相关工具
sudo dnf install -y nfs-kernel-server nfs-client openssh-clients

# 安装编译工具和运行时
sudo dnf install -y python3 python3-pip rust gcc gcc-c++ git beakerlib
```

> **注意**：
> - `gcc` 和 `gcc-c++` 用于编译 Python C 扩展（如 ruamel-yaml-clib）
> - `python3-devel` 通常已包含在 python3 包中，如缺失需单独安装
> - `rust` 是某些 Rust 编写的 Python 包的编译依赖

**步骤 2：通过 pip 安装 tmt**

```bash
# 使用 --break-system-packages 标志（系统 Python 环境）
sudo pip3 install --break-system-packages tmt
```

**安装说明：**
- riscv64 架构首次安装可能需要 **10-20 分钟**，因为需要编译多个 Python 包
- 关键编译包：`ruamel-yaml-clib`、`pydantic-core`、`rpds-py` 等
- 建议使用 `nohup` 或 `screen` 在后台运行，避免 SSH 断开导致中断
- 编译过程 CPU 占用率会较高（90%+），这是正常现象

**验证安装：**

```bash
# 检查 tmt 版本（首次运行可能需要 2-3 分钟加载）
tmt --version

# 预期输出
tmt version: 1.75.0
```

### 初始化

```bash
# 克隆项目后，确认 .fmf 目录存在
ls .fmf/version
```

## 常用命令

### 查看测试

```bash
# 列出所有测试用例
tmt test ls

# 查看测试详情
tmt test show

# 查看特定测试
tmt test show /tests/smoke

# 查看所有元数据概览
tmt
```

### 查看计划

```bash
# 列出所有测试计划
tmt plan ls

# 查看计划详情
tmt plan show /plans/smoke
```

### 执行测试

```bash
# 在本地执行冒烟测试
tmt run plan --name /plans/smoke

# 在本地执行所有测试
tmt run --all provision --how local

# 在容器中执行功能测试
tmt run plan --name /plans/functional provision --how container

# 在虚拟机中执行（安全隔离）
tmt run --all provision --how virtual --image fedora-38

# 查看上次执行结果（详细模式）
tmt run --last report -fvvv
```

### 分步执行

```bash
# 仅执行发现步骤（查看哪些测试会被执行）
tmt run discover

# 详细模式查看
tmt run discover -v

# 仅执行准备步骤
tmt run prepare --how install --package curl
```

## 添加新测试

### 创建 Shell 测试

```bash
# 创建 shell 测试模板
tmt test create --template shell /tests/my_test

# 编辑元数据
vim tests/my_test/main.fmf

# 编辑测试脚本
vim tests/my_test/test.sh
```

**main.fmf 示例：**

```yaml
summary: 我的测试 - 简短描述
test: ./test.sh
tag:
  - functional
  - my-feature
duration: 2m
tier: 1
require:
  - curl
  - wget
```

**test.sh 示例：**

```bash
#!/bin/sh -eux
# 测试脚本：使用 -e 遇错退出，-u 未定义变量报错，-x 显示执行过程

echo "开始测试..."
# 测试逻辑
echo "测试通过!"
```

### 创建 BeakerLib 测试

```bash
tmt test create --template beakerlib /tests/my_beakerlib_test
```

### 创建测试计划

```bash
# 创建 mini 计划（仅脚本执行）
tmt plan create --template mini /plans/my_plan

# 创建 base 计划（fmf 发现 + beakerlib 执行）
tmt plan create --template base /plans/my_plan

# 创建 full 计划（远程仓库引用）
tmt plan create --template full /plans/my_plan
```

## 元数据字段说明

### 测试级别 (tests/)

| 字段 | 类型 | 说明 |
|------|------|------|
| `summary` | string | 测试简短描述 |
| `test` | string | 测试脚本路径 |
| `framework` | string | 测试框架：`shell` 或 `beakerlib` |
| `tag` | list | 标签，用于分类和筛选 |
| `duration` | string | 最大执行时间（如 `5m`、`1h`） |
| `tier` | int | 优先级：0=核心，数字越大优先级越低 |
| `require` | list | 依赖的软件包 |
| `recommend` | list | 推荐的软件包 |
| `environment` | dict | 环境变量 |
| `enabled` | bool | 是否启用（默认 true） |
| `path` | string | 测试执行的工作目录 |
| `contact` | string | 测试负责人 |
| `link` | list | 关联的关系链接 |

### 计划级别 (plans/)

| 字段 | 类型 | 说明 |
|------|------|------|
| `summary` | string | 计划简短描述 |
| `discover` | dict | 测试发现配置（`how: fmf`） |
| `provision` | dict | 环境供给配置（`how: local/container/virtual`） |
| `prepare` | dict | 环境准备配置（`how: install/shell/ansible`） |
| `execute` | dict | 测试执行配置（`how: tmt`） |
| `report` | dict | 结果报告配置（`how: display/html/junit`） |
| `finish` | dict | 清理步骤配置 |
| `context` | dict | 上下文维度调整 |
| `environment` | dict | 环境变量 |

### FMF 继承机制

`tests/main.fmf` 中定义的配置会自动被子目录继承：

```yaml
# tests/main.fmf - 所有测试的共享配置
framework: shell          # 默认框架
duration: 5m              # 默认超时
contact: QA Team <qa@example.com>
enabled: true
path: /
```

子测试目录只需定义差异化的配置：

```yaml
# tests/smoke/main.fmf - 覆盖 duration 和 tier
summary: 冒烟测试
test: ./test.sh
tag: smoke
duration: 1m              # 覆盖为 1 分钟
tier: 0
```

## 测试标签体系

| 标签 | 说明 | tier | 计划 |
|------|------|------|------|
| `smoke` | 冒烟测试 - 核心功能快速验证 | 0 | `/plans/smoke` |
| `functional` | 功能测试 - 完整功能验证 | 1 | `/plans/functional` |
| `security` | 安全测试 - 系统安全特性验证 | 1 | `/plans/security` |
| `compatibility` | 兼容性测试 - 多环境兼容性验证 | 2 | `/plans/compatibility` |
| `performance` | 性能测试 - 系统性能指标验证 | 2 | `/plans/performance` |
| `reliability` | 可靠性测试 - 系统稳定性验证 | 2 | `/plans/reliability` |
| `integration` | 集成测试 - 跨组件验证 | 2 | `/plans/integration` |

### tier 分级策略

| tier | 触发时机 | 包含测试 |
|------|---------|---------|
| **0** | 每次提交 / PR | 冒烟测试 |
| **1** | 每日构建 | 功能测试 + 安全测试 |
| **2** | 发布前验证 | 兼容性 + 性能 + 可靠性 + 集成测试 |

## 参考资源

- [tmt 官方文档](https://docs.fedoraproject.org/en-US/ci/tmt/)
- [tmt 详细指南](https://tmt.readthedocs.io/en/stable/guide.html)
- [tmt 元数据规范](https://tmt.readthedocs.io/en/stable/spec.html)
- [FMF 格式说明](https://fmf.readthedocs.io/)
- [tmt GitHub 仓库](https://github.com/teemtee/tmt)

## 项目约定

- 所有 `.fmf` 文件使用 YAML 格式
- 测试脚本使用 `#!/bin/sh -eux`（遇错退出、显示执行过程）
- `.fmf/` 目录必须提交到 Git
- 测试标签使用小写英文，多词用连字符连接
- 通过 `tests/main.fmf` 定义共享配置，子目录按需覆盖