#!/bin/sh -eux
# 功能测试: 验证系统基本命令可用性

echo "=== 测试系统基本命令 ==="

# 测试 hostname 命令
echo "1. 测试 hostname 命令..."
hostname=$(hostname)
echo "   主机名: $hostname"
test -n "$hostname"

# 测试 whoami 命令
echo "2. 测试 whoami 命令..."
whoami=$(whoami)
echo "   当前用户: $whoami"
test -n "$whoami"

# 测试 uname 命令
echo "3. 测试 uname 命令..."
uname -a

# 测试 ls 命令
echo "4. 测试 ls 命令..."
ls -la /tmp

# 测试 echo 命令
echo "5. 测试 echo 命令..."
result=$(echo "hello world")
echo "   $result"
test "$result" = "hello world"

echo ""
echo "所有功能测试通过!"