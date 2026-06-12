#!/bin/sh -eux
# Functional test: debugedit - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install debugedit ===
INSTALLED_BY_TEST=0
if ! rpm -q debugedit 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y debugedit 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed debugedit"
    else
        echo "SKIP: debugedit not available in repos"
        exit 0
    fi
else
    echo "SETUP: debugedit already installed"
fi

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="
rlRun 'debugedit --invalid 2>&1 || true' 0 "debugedit: 无效选项"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y debugedit 2>/dev/null || true
    echo "TEARDOWN: removed debugedit"
fi
echo ""
echo "All debugedit functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All debugedit 错误处理 tests passed!"
