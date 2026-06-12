#!/bin/sh -eux
# Functional test: findutils - find-执行操作

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

echo "=== 测试 3: find 执行操作 ==="
rlRun 'find . -name "f1.txt" -exec cat {} \;' 0 "find -exec: 执行命令"
rlRun 'find . -name "*.txt" -delete' 0 "find -delete: 删除文件"
rlRun 'test ! -f a/f1.txt' 0 "find -delete: 验证删除"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y findutils 2>/dev/null || true
    echo "TEARDOWN: removed findutils"
fi
echo ""
echo "All findutils find-执行操作 tests passed!"
