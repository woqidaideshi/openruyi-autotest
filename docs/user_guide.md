# 用户指南

> 适用于**干净服务器**环境，从零开始执行测试。

---

## 1. 环境准备

### 1.1 安装 git

```bash
sudo dnf install -y git
```

### 1.2 克隆代码仓库

```bash
git clone https://git.openruyi.cn/woqidaideshi/openruyi-autotest.git
cd openruyi-autotest
```

### 1.3 安装 tmt 和 beakerlib

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

## 2. 执行单个测试用例

比如 acl 测试套中的 `test_acl_getfacl_basic`：

```bash
cd openruyi-autotest

tmt run --verbose plan --name /plans/functional \
    test --name /tests/functional/pkgs/acl/test_acl_getfacl_basic \
    provision --feeling-safe
```

---

## 3. 执行单个测试套

比如 acl：

```bash
cd openruyi-autotest

tmt run plan --name /plans/functional \
    test --name /tests/functional/pkgs/acl \
    provision --feeling-safe
```

---

## 4. 执行测试类型全量用例

比如功能测试（functional），包含 202 个软件包，共 566 个测试用例：

```bash
cd openruyi-autotest

tmt run plan --name /plans/functional \
    provision --feeling-safe
```

---

## 5. 查看测试结果和日志

### 5.1 tmt 结果目录

tmt 每次执行都会在 `/var/tmp/tmt/run-*` 下生成一个运行目录，包含所有测试用例的详细日志：

```bash
# 列出所有历史运行
ls -lt /var/tmp/tmt/

# 进入最近一次运行目录
cd $(ls -dt /var/tmp/tmt/run-* | head -1)
```

运行目录结构：

```
/var/tmp/tmt/run-XXX/
├── plan/
│   └── execute/
│       └── data/
│           └── tests/functional/pkgs/acl/
│               ├── test_acl_getfacl_basic/
│               │   └── output.txt    # 该用例的完整输出
│               ├── test_acl_setfacl_basic/
│               │   └── output.txt
│               └── ...
└── run.yaml                         # 运行元数据
```

### 5.2 查看单个用例日志

```bash
# 进入最近一次运行目录
RUN_DIR=$(ls -dt /var/tmp/tmt/run-* | head -1)

# 查看某个测试用例的完整输出
cat $RUN_DIR/plan/execute/data/tests/functional/pkgs/acl/test_acl_getfacl_basic/output.txt
```

### 5.3 查看汇总报告

```bash
# 简要报告
tmt run --last report

# 详细报告（含每个用例的 stdout/stderr）
tmt run --last report -fvvv
```

### 5.4 查看所有用例的执行状态

```bash
RUN_DIR=$(ls -dt /var/tmp/tmt/run-* | head -1)

# 列出所有用例的 output.txt 并显示最后几行（通常包含 PASS/FAIL）
find $RUN_DIR -name "output.txt" | while read f; do
    dir=$(dirname "$f")
    echo "=== $(basename "$dir") ==="
    tail -5 "$f"
    echo ""
done
```

---

## 6. 执行所有测试脚本

从项目根目录执行全部测试（所有计划）：

```bash
cd openruyi-autotest

tmt run --all provision --how local --feeling-safe
```

---

## 7. 目录结构速查

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

## 8. 常见问题

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
