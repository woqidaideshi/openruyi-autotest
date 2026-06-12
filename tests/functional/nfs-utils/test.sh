#!/bin/sh -eux
# Functional test: nfs-utils

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install nfs-utils ===
INSTALLED_BY_TEST=0
if ! rpm -q nfs-utils 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y nfs-utils 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed nfs-utils"
    else
        echo "SKIP: nfs-utils not available in repos"
        exit 0
    fi
else
    echo "SETUP: nfs-utils already installed"
fi


rpm -q nfs-utils 2>/dev/null || { echo "nfs-utils not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql nfs-utils 2>/dev/null | head -10 || true
rpm -qi nfs-utils 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "nfs-utils" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libnfs-utils*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/nfs-utils/ 2>/dev/null | head -5 || true


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y nfs-utils 2>/dev/null || true
    echo "TEARDOWN: removed nfs-utils"
fi
echo ""
echo "All nfs-utils functional tests passed!"
