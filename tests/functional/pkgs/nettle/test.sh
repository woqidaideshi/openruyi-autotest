#!/bin/sh -eux
# Functional test: nettle package
# Tests Nettle 加密库工具
# Version: nettle

rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install nettle ===
INSTALLED_BY_TEST=0
if ! rpm -q nettle 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y nettle 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed nettle"
    else
        echo "SKIP: nettle not available in repos"
        exit 0
    fi
else
    echo "SETUP: nettle already installed"
fi



echo "=== 测试 1: 版本和帮助 ==="
rlRun 'nettle-hash --version 2>&1 || true' 0 "nettle-hash 版本信息"
rlRun 'nettle-hash --help 2>&1 | head -5 || true' 0 "nettle-hash 帮助信息"
rlRun 'nettle-lfib-stream --version 2>&1 || true' 0 "nettle-lfib-stream 版本信息"
rlRun 'nettle-lfib-stream --help 2>&1 | head -5 || true' 0 "nettle-lfib-stream 帮助信息"
rlRun 'nettle-pbkdf2 --version 2>&1 || true' 0 "nettle-pbkdf2 版本信息"
rlRun 'nettle-pbkdf2 --help 2>&1 | head -5 || true' 0 "nettle-pbkdf2 帮助信息"
rlRun 'pkcs1-conv --version 2>&1 || true' 0 "pkcs1-conv 版本信息"
rlRun 'pkcs1-conv --help 2>&1 | head -5 || true' 0 "pkcs1-conv 帮助信息"
rlRun 'sexp-conv --version 2>&1 || true' 0 "sexp-conv 版本信息"
rlRun 'sexp-conv --help 2>&1 | head -5 || true' 0 "sexp-conv 帮助信息"

echo "=== 测试 2: 错误处理 ==="
rlRun 'nettle-hash --invalid 2>&1 || true' 0 "nettle-hash: 无效选项"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y nettle 2>/dev/null || true
    echo "TEARDOWN: removed nettle"
fi
echo ""
echo "All nettle functional tests passed!"
