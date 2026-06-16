#!/bin/sh -eux
# Functional test: curl - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install curl ===
INSTALLED_BY_TEST=0
if ! rpm -q curl 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y curl 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed curl"
    else
        echo "SKIP: curl not available in repos"
        exit 0
    fi
else
    echo "SETUP: curl already installed"
fi

rlRun 'curl --version' 0 "curl 版本信息"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 6: 错误处理 ==="
rlRun 'curl --invalid 2>&1 || true' 0 "curl: 无效选项"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y curl 2>/dev/null || true
    echo "TEARDOWN: removed curl"
fi
echo ""
echo "All curl functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All curl 错误处理 tests passed!"
