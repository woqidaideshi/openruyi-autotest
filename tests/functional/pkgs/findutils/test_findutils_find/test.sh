#!/bin/sh -eux
# Functional test: findutils - find-基本查找

rlRun() { eval "$1" 2>&1; return $?; }
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



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y findutils 2>/dev/null || true
    echo "TEARDOWN: removed findutils"
fi
echo ""
echo "All findutils find-基本查找 tests passed!"
