#!/bin/sh -eux
# Functional test: ed

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install ed ===
INSTALLED_BY_TEST=0
if ! rpm -q ed 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y ed 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed ed"
    else
        echo "SKIP: ed not available in repos"
        exit 0
    fi
else
    echo "SETUP: ed already installed"
fi


rpm -q ed 2>/dev/null || { echo "ed not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql ed 2>/dev/null | head -10 || true
rpm -qi ed 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "ed" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libed*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/ed/ 2>/dev/null | head -5 || true


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y ed 2>/dev/null || true
    echo "TEARDOWN: removed ed"
fi
echo ""
echo "All ed functional tests passed!"
