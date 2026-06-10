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
│   ├── security/                 # 安全测试
│   ├── compatibility/            # 兼容性测试
│   ├── performance/              # 性能测试
│   └── reliability/              # 可靠性测试
├── stories/                     # 用户故事
│   └── init.fmf
└── README.md
```

## 快速开始

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

## 用例数量统计

> 每次新增测试脚本后需同步更新此表格。

### 按测试类型分类

| 测试类型 | 软件包 | 用例数 |
|---------|--------|--------|
| **Smoke** (冒烟测试) | tmt | 1 |
| | **小计** | **1** |
| **Functional** (功能测试) | acl | 11 |
| | cmake | 7 |
| | iputils | 10 |
| | pciutils | 12 |
| | podmansh | 12 |
| | procps-ng | 12 |
| | psmisc | 13 |
| | rpmbuild | 9 |
| | tar | 10 |
| | wget | 15 |
| | wget2 | 15 |
| | **小计 (11 包)** | **126** |
| **Compatibility** (兼容性测试) | system | 5 |
| | **小计** | **5** |
| **Security** (安全测试) | system | 4 |
| | **小计** | **4** |
| **Performance** (性能测试) | system | 5 |
| | **小计** | **5** |
| **Reliability** (可靠性测试) | system | 5 |
| | **小计** | **5** |
| **合计** | **6 类 / 12 包** | **146** |

### 汇总

| 测试类型 | 软件包数 | 用例数 |
|---------|:------:|:----:|
| Smoke | 1 | 1 |
| Functional | 11 | 126 |
| Compatibility | 1 | 5 |
| Security | 1 | 4 |
| Performance | 1 | 5 |
| Reliability | 1 | 5 |
| **合计** | **16** | **146** |

## 远程服务器操作

项目提供了 SSH 远程命令执行工具，详见 `.trellis/scripts/ssh_exec.py`。

### 测试服务器环境

**服务器配置：**
- 服务器地址：`10.20.237.192`
- SSH 端口：`12055`
- 普通用户：`openruyi`
- 提权方式：`sudo -i` 或 `sudo <command>`（密码同普通用户）
- 系统架构：riscv64 (openRuyi Creek)

**SSH 连接示例：**

```bash
# 基本连接
ssh -p 12055 openruyi@10.20.237.192

# 使用项目工具执行远程命令
python .trellis/scripts/ssh_exec.py 10.20.237.192 openruyi openruyi "命令" --port 12055

# 执行需要 root 权限的命令
python .trellis/scripts/ssh_exec.py 10.20.237.192 openruyi openruyi "命令" --port 12055 --sudo
```

**已预装的软件：**
- tmt 1.75.0
- python3 3.13.8
- gcc 16, g++, rust 1.94.1
- git 2.54.0
- beakerlib 1.33.3
- nfs-kernel-server, nfs-client, openssh-clients

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