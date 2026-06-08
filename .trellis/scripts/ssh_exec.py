#!/usr/bin/env python3
"""
SSH 远程命令执行工具
通过 SSH_ASKPASS 机制实现密码认证，在远程服务器上执行命令并返回结果。

用法:
    python ssh_exec.py <host> <user> <password> <command> [--port 22] [--timeout 30]

示例:
    python ssh_exec.py 10.20.238.235 root 'ISRCpassword@123' 'ls -la'
    python ssh_exec.py 10.20.238.235 root 'ISRCpassword@123' 'cat /etc/os-release' --port 2222
"""

import subprocess
import os
import sys
import tempfile
import argparse
import shutil


def create_askpass_script(password: str) -> str:
    """
    创建 SSH_ASKPASS 密码提供脚本。
    返回脚本文件路径。
    """
    # 使用 Python 作为 askpass 程序，更可靠
    script_content = f'''@echo off
echo {password}
'''
    tmp_dir = tempfile.gettempdir()
    script_path = os.path.join(tmp_dir, f'ssh_askpass_{os.getpid()}.bat')
    with open(script_path, 'w') as f:
        f.write(script_content)
    return script_path


def ssh_exec(
    host: str,
    user: str,
    password: str,
    command: str,
    port: int = 22,
    timeout: int = 30
) -> tuple[int, str, str]:
    """
    通过 SSH 在远程服务器上执行命令。

    Args:
        host: 服务器 IP 或主机名
        user: SSH 用户名
        password: SSH 密码
        command: 要执行的命令
        port: SSH 端口，默认 22
        timeout: 超时时间（秒），默认 30

    Returns:
        (return_code, stdout, stderr) 元组
    """
    ssh_exe = shutil.which('ssh') or r'C:\Windows\System32\OpenSSH\ssh.exe'

    # 创建密码提供脚本
    askpass_script = create_askpass_script(password)

    try:
        # 设置环境变量
        env = os.environ.copy()
        env['SSH_ASKPASS'] = askpass_script
        env['SSH_ASKPASS_REQUIRE'] = 'force'
        env['DISPLAY'] = 'dummy'

        # 构建 SSH 命令
        ssh_cmd = [
            ssh_exe,
            '-o', 'StrictHostKeyChecking=no',
            '-o', 'UserKnownHostsFile=NUL',
            '-o', 'PasswordAuthentication=yes',
            '-o', 'PreferredAuthentications=password',
            '-o', 'PubkeyAuthentication=no',
            '-o', f'ConnectTimeout={timeout}',
            '-p', str(port),
            f'{user}@{host}',
            command
        ]

        proc = subprocess.Popen(
            ssh_cmd,
            env=env,
            stdin=subprocess.DEVNULL,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
        )

        try:
            stdout, stderr = proc.communicate(timeout=timeout + 10)
        except subprocess.TimeoutExpired:
            proc.kill()
            stdout, stderr = proc.communicate()
            return (-1, '', f'SSH command timed out after {timeout}s')

        # 解码输出
        stdout_str = stdout.decode('utf-8', errors='replace').strip()
        stderr_str = stderr.decode('utf-8', errors='replace').strip()

        # 过滤掉 SSH 警告信息（如 known_hosts 警告和 banner）
        filtered_stderr_lines = []
        for line in stderr_str.split('\n'):
            line = line.strip()
            if not line:
                continue
            if 'Warning: Permanently added' in line:
                continue
            if 'Authorized users only' in line:
                continue
            filtered_stderr_lines.append(line)
        stderr_str = '\n'.join(filtered_stderr_lines)

        return (proc.returncode, stdout_str, stderr_str)

    finally:
        # 清理密码脚本
        try:
            os.remove(askpass_script)
        except OSError:
            pass


def main():
    parser = argparse.ArgumentParser(
        description='SSH 远程命令执行工具',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog='''
示例:
  python ssh_exec.py 10.20.238.235 root 'ISRCpassword@123' 'ls -la'
  python ssh_exec.py 10.20.238.235 root 'ISRCpassword@123' 'hostname' --port 22
        '''
    )
    parser.add_argument('host', help='服务器 IP 或主机名')
    parser.add_argument('user', help='SSH 用户名')
    parser.add_argument('password', help='SSH 密码')
    parser.add_argument('command', help='要执行的命令')
    parser.add_argument('--port', type=int, default=22, help='SSH 端口 (默认: 22)')
    parser.add_argument('--timeout', type=int, default=30, help='超时时间/秒 (默认: 30)')

    args = parser.parse_args()

    rc, stdout, stderr = ssh_exec(
        host=args.host,
        user=args.user,
        password=args.password,
        command=args.command,
        port=args.port,
        timeout=args.timeout
    )

    if stdout:
        print(stdout)
    if stderr:
        print(stderr, file=sys.stderr)

    sys.exit(rc)


if __name__ == '__main__':
    main()