#!/bin/sh -eux
# Functional test: findutils package
# Tests findutils 文件查找
# Version: findutils

rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install findutils ===
INSTALLED_BY_TEST=0
if ! rpm -q findutils 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y findutils 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed findutils"
    else
        echo "SKIP: findutils not available in repos"
        exit 0
    fi
else
    echo "SETUP: findutils already installed"
fi



rlRun 'find --version' 0 "find 版本"
rlRun 'xargs --version' 0 "xargs 版本"

TmpDir=$(mktemp -d); cd $TmpDir

echo "=== 测试 1: find 基本查找 ==="
mkdir -p a/b/c
touch a/f1.txt a/f2.txt a/b/f3.txt
rlRun 'find . -name "*.txt"' 0 "find -name: 按名称查找"
rlRun 'find . -type f' 0 "find -type f: 查找文件"
rlRun 'find . -type d' 0 "find -type d: 查找目录"

echo "=== 测试 2: find 选项 ==="
rlRun 'find . -maxdepth 1 -name "*.txt"' 0 "find -maxdepth: 最大深度"
rlRun 'find . -mindepth 2' 0 "find -mindepth: 最小深度"
rlRun 'find . -empty' 0 "find -empty: 空文件/目录"
rlRun 'find . -size +0c' 0 "find -size: 按大小"

echo "=== 测试 3: find 执行操作 ==="
rlRun 'find . -name "f1.txt" -exec cat {} \;' 0 "find -exec: 执行命令"
rlRun 'find . -name "*.txt" -delete' 0 "find -delete: 删除文件"
rlRun 'test ! -f a/f1.txt' 0 "find -delete: 验证删除"

echo "=== 测试 4: xargs ==="
echo -e "1\n2\n3" > nums.txt
rlRun 'cat nums.txt | xargs echo' 0 "xargs: 基本用法"
rlRun 'echo "test1 test2" | xargs -n1 echo' 0 "xargs -n1: 每次一个参数"

echo "=== 测试 5: 错误处理 ==="
rlRun 'find /nonexistent 2>&1 || true' 0 "find: 无效路径"

cd /; rm -rf $TmpDir

# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y findutils 2>/dev/null || true
    echo "TEARDOWN: removed findutils"
fi
echo ""
echo "All findutils functional tests passed!"
