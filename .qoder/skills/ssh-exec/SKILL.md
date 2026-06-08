---
name: ssh-exec
description: "SSH 远程命令执行工具。通过 SSH_ASKPASS 机制实现密码认证，在远程 Linux 服务器上执行命令并获取结果。适用于需要在远程服务器执行运维命令、部署脚本、检查系统状态等场景。"
---

# SSH 远程命令执行

通过 SSH 密码认证连接到远程服务器，执行命令并返回结果。

## 使用方法

使用 `.trellis/scripts/ssh_exec.py` 脚本：

```bash
python .trellis/scripts/ssh_exec.py <host> <user> <password> <command> [--port 22] [--timeout 30]
```

### 参数说明

| 参数 | 说明 | 必填 |
|------|------|------|
| `host` | 服务器 IP 或主机名 | 是 |
| `user` | SSH 用户名 | 是 |
| `password` | SSH 密码 | 是 |
| `command` | 要执行的命令（用引号包裹） | 是 |
| `--port` | SSH 端口，默认 22 | 否 |
| `--timeout` | 超时时间（秒），默认 30 | 否 |

### 返回值

- 标准输出打印到 stdout
- 标准错误打印到 stderr
- 退出码为命令的返回码（0 表示成功）

## 使用示例

### 基本命令执行

```bash
# 列出远程目录
python .trellis/scripts/ssh_exec.py 10.20.238.235 root 'ISRCpassword@123' 'ls -la /root'

# 查看系统信息
python .trellis/scripts/ssh_exec.py 10.20.238.235 root 'ISRCpassword@123' 'cat /etc/os-release'

# 查看磁盘使用
python .trellis/scripts/ssh_exec.py 10.20.238.235 root 'ISRCpassword@123' 'df -h'

# 检查进程
python .trellis/scripts/ssh_exec.py 10.20.238.235 root 'ISRCpassword@123' 'ps aux | head -20'
```

### 多命令执行（用分号或 && 连接）

```bash
python .trellis/scripts/ssh_exec.py 10.20.238.235 root 'ISRCpassword@123' 'cd /tmp && ls -la'
```

### 安装软件包

```bash
python .trellis/scripts/ssh_exec.py 10.20.238.235 root 'ISRCpassword@123' 'dnf install -y tmt'
```

### 创建目录

```bash
python .trellis/scripts/ssh_exec.py 10.20.238.235 root 'ISRCpassword@123' 'mkdir -p /opt/test-project'
```

## 技术原理

该工具通过 Windows 版 OpenSSH 客户端的 `SSH_ASKPASS` 机制实现密码认证：

1. 创建临时批处理脚本，内容为输出密码
2. 设置环境变量 `SSH_ASKPASS`、`SSH_ASKPASS_REQUIRE=force`、`DISPLAY=dummy`
3. 调用 `ssh.exe` 执行远程命令
4. 执行完毕后清理临时密码脚本

## Python API 调用

如果需要在 Python 代码中调用，可以直接导入 `ssh_exec` 函数：

```python
import sys
sys.path.insert(0, '.trellis/scripts')
from ssh_exec import ssh_exec

rc, stdout, stderr = ssh_exec(
    host='10.20.238.235',
    user='root',
    password='ISRCpassword@123',
    command='ls -la',
    port=22,
    timeout=30
)
print(stdout)
```