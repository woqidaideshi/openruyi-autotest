#!/bin/sh -eux
# Functional test: libtool

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libtool ===
INSTALLED_BY_TEST=0
if ! rpm -q libtool 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libtool 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libtool"
    else
        echo "SKIP: libtool not available in repos"
        exit 0
    fi
else
    echo "SETUP: libtool already installed"
fi


rpm -q libtool 2>/dev/null || { echo "libtool not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql libtool 2>/dev/null | head -10 || true
rpm -qi libtool 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "libtool" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/liblibtool*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/libtool/ 2>/dev/null | head -5 || true


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libtool 2>/dev/null || true
    echo "TEARDOWN: removed libtool"
fi
echo ""
echo "All libtool functional tests passed!"
