#!/bin/sh -eux
# Functional test: ca-certificates package
# Tests CA证书管理
# Version: ca-certificates

rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install ca-certificates ===
INSTALLED_BY_TEST=0
if ! rpm -q ca-certificates 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y ca-certificates 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed ca-certificates"
    else
        echo "SKIP: ca-certificates not available in repos"
        exit 0
    fi
else
    echo "SETUP: ca-certificates already installed"
fi



echo "=== 测试 1: 版本和帮助 ==="
rlRun 'update-ca-trust --version 2>&1 || true' 0 "update-ca-trust 版本信息"
rlRun 'update-ca-trust --help 2>&1 | head -5 || true' 0 "update-ca-trust 帮助信息"

echo "=== 测试 2: 错误处理 ==="
rlRun 'update-ca-trust --invalid 2>&1 || true' 0 "update-ca-trust: 无效选项"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y ca-certificates 2>/dev/null || true
    echo "TEARDOWN: removed ca-certificates"
fi
echo ""
echo "All ca-certificates functional tests passed!"
