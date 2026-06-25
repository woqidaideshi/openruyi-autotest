# 手动执行测试脚本指南

> 适用于未安装 tmt 框架的**干净服务器**环境，从零开始手动执行所有测试。

---

## 1. 环境准备

### 1.1 克隆代码仓库

```bash
git clone https://git.openruyi.cn/woqidaideshi/openruyi-autotest.git
cd openruyi-autotest
```

### 1.2 安装 tmt 和 beakerlib

测试用例使用 tmt (Test Management Tool) 框架管理和执行：

```bash
# 安装 tmt（基础版，支持本地执行）
sudo dnf install -y tmt

# 安装 beakerlib 测试框架
sudo dnf install -y beakerlib

# 验证安装
tmt --version
rpm -q beakerlib
```

> **riscv64 架构**：`tmt` 可能不在 dnf 仓库中，可通过 pip 安装：
> ```bash
> sudo dnf install -y python3 python3-pip rust gcc gcc-c++ beakerlib
> sudo pip3 install --break-system-packages tmt
> ```

---

## 2. 执行单个 ACL 测试用例

以 `test_acl_getfacl_basic`（getfacl 基本功能测试）为例：

```bash
cd openruyi-autotest

tmt run --verbose plan --name /plans/functional \
    test --name /tests/functional/pkgs/acl/test_acl_getfacl_basic
```

**执行其他 ACL 用例**，修改 `--name` 参数即可：

```bash
# getfacl 基本功能
tmt run plan --name /plans/functional test --name /tests/functional/pkgs/acl/test_acl_getfacl_basic

# setfacl 基本功能
tmt run plan --name /plans/functional test --name /tests/functional/pkgs/acl/test_acl_setfacl_basic

# setfacl 高级功能
tmt run plan --name /plans/functional test --name /tests/functional/pkgs/acl/test_acl_setfacl_advanced

# setfacl 递归设置
tmt run plan --name /plans/functional test --name /tests/functional/pkgs/acl/test_acl_setfacl_recursive

# setfacl 删除 ACL
tmt run plan --name /plans/functional test --name /tests/functional/pkgs/acl/test_acl_setfacl_remove

# 软链接 ACL
tmt run plan --name /plans/functional test --name /tests/functional/pkgs/acl/test_acl_setfacl_symlink

# ACL 继承
tmt run plan --name /plans/functional test --name /tests/functional/pkgs/acl/test_acl_acl_inheritance

# ACL 权限校验
tmt run plan --name /plans/functional test --name /tests/functional/pkgs/acl/test_acl_acl_permission_verify

# chacl 命令
tmt run plan --name /plans/functional test --name /tests/functional/pkgs/acl/test_acl_chacl_command

# 错误处理
tmt run plan --name /plans/functional test --name /tests/functional/pkgs/acl/test_acl_error_handling

# 特殊情况
tmt run plan --name /plans/functional test --name /tests/functional/pkgs/acl/test_acl_special_cases
```

---

## 3. 执行 ACL 测试套

一次性执行整个 ACL 测试套（所有 11 个测试用例）：

```bash
cd openruyi-autotest

tmt run plan --name /plans/functional \
    test --name /tests/functional/pkgs/acl
```

---

## 4. 执行某一类测试

### 4.1 执行全部功能测试（functional）

功能测试包含 202 个软件包，共 566 个测试用例：

```bash
cd openruyi-autotest

tmt run plan --name /plans/functional
```

### 4.2 执行全部冒烟测试（smoke）

```bash
tmt run plan --name /plans/smoke
```

### 4.3 执行全部安全测试（security）

```bash
tmt run plan --name /plans/security
```

### 4.4 执行全部兼容性测试（compatibility）

```bash
tmt run plan --name /plans/compatibility
```

### 4.5 执行全部性能测试（performance）

```bash
tmt run plan --name /plans/performance
```

### 4.6 执行全部可靠性测试（reliability）

```bash
tmt run plan --name /plans/reliability
```

---

## 5. 执行所有测试脚本

从项目根目录执行全部测试（所有计划）：

```bash
cd openruyi-autotest

tmt run --all provision --how local
```

### 5.1 查看执行结果

```bash
# 查看上次执行结果（简要）
tmt run --last report

# 查看上次执行结果（详细模式，含输出）
tmt run --last report -fvvv
```

### 5.2 按标签过滤执行

```bash
# 仅执行带 functional 标签的测试
tmt run discover --how fmf --filter tag:functional provision --how local

# 仅执行 tier 0 的测试（冒烟级）
tmt run discover --how fmf --filter tier:0 provision --how local
```

---

## 6. 目录结构速查

---

## 6. 目录结构速查

```
tests/
├── smoke/             # 冒烟测试（100 个用例）
│   ├── archive/       # 归档工具（tar, gzip, xz）
│   ├── dev_tools/     # 开发工具
│   ├── disk_fs/       # 磁盘/文件系统
│   ├── filesystem/    # 文件系统操作
│   ├── kernel/        # 内核功能
│   ├── logging/       # 日志系统
│   ├── network/       # 网络工具
│   ├── package_mgmt/  # 包管理
│   ├── permissions/   # 权限管理
│   ├── process/       # 进程管理
│   ├── scripting/     # 脚本语言
│   ├── security/      # 安全相关
│   ├── service_mgmt/  # 服务管理
│   ├── shell_basics/  # Shell 基础
│   ├── system_info/   # 系统信息
│   ├── text_processing/# 文本处理
│   └── user_mgmt/     # 用户管理
├── functional/pkgs/   # 功能测试（202 个包, 566 用例）
│   ├── acl/           # ACL 权限管理（参考标准）
│   ├── attr/          # 扩展属性
│   ├── bash/          # Bash shell
│   ├── coreutils/     # 核心工具集
│   ├── ...            # 更多软件包
├── security/          # 安全测试（106 个用例）
│   ├── cve/           # CVE 漏洞验证
│   └── nmap/          # Nmap 端口扫描
├── compatibility/     # 兼容性测试（188 个用例）
│   └── ltp_posix/     # LTP POSIX 接口兼容性
├── performance/       # 性能测试
│   └── unixbench/     # UnixBench 基准测试
└── reliability/       # 可靠性测试
    └── test.sh
```

---

## 7. 常见问题

### Q: 执行报错 `beakerlib.sh: No such file or directory`

```bash
sudo dnf install -y beakerlib
```

### Q: tmt 命令找不到

```bash
# dnf 安装
sudo dnf install -y tmt

# 或 pip 安装（riscv64）
sudo pip3 install --break-system-packages tmt
```

### Q: 测试因权限不足失败

部分测试脚本使用 `sudo` 执行特权操作，需确保当前用户有 sudo 权限：

```bash
# 验证 sudo 可用
sudo whoami
```

### Q: 只想查看某个计划包含哪些测试（不执行）

```bash
tmt plan show /plans/functional
tmt test ls /tests/functional/pkgs/acl
```

### Q: 查看上次执行的详细信息

```bash
tmt run --last report -fvvv
```
