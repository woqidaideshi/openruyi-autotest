#!/bin/sh -eux
# Functional test: findutils - find-选项

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

echo "=== 测试 2: find 选项 ==="
rlRun 'find . -maxdepth 1 -name "*.txt"' 0 "find -maxdepth: 最大深度"
rlRun 'find . -mindepth 2' 0 "find -mindepth: 最小深度"
rlRun 'find . -empty' 0 "find -empty: 空文件/目录"
rlRun 'find . -size +0c' 0 "find -size: 按大小"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y findutils 2>/dev/null || true
    echo "TEARDOWN: removed findutils"
fi
echo ""
echo "All findutils find-选项 tests passed!"
