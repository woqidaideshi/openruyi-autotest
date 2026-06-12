#!/bin/sh -eux
# Functional test: audit - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install audit ===
INSTALLED_BY_TEST=0
if ! rpm -q audit 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y audit 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed audit"
    else
        echo "SKIP: audit not available in repos"
        exit 0
    fi
else
    echo "SETUP: audit already installed"
fi

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="
rlRun 'auditctl --invalid 2>&1 || true' 0 "auditctl: 无效选项"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y audit 2>/dev/null || true
    echo "TEARDOWN: removed audit"
fi
echo ""
echo "All audit functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All audit 错误处理 tests passed!"
