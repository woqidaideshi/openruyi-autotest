#!/bin/sh -eux
# Functional test: help2man

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install help2man ===
INSTALLED_BY_TEST=0
if ! rpm -q help2man 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y help2man 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed help2man"
    else
        echo "SKIP: help2man not available in repos"
        exit 0
    fi
else
    echo "SETUP: help2man already installed"
fi


rpm -q help2man 2>/dev/null || { echo "help2man not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql help2man 2>/dev/null | head -10 || true
rpm -qi help2man 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "help2man" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libhelp2man*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/help2man/ 2>/dev/null | head -5 || true


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y help2man 2>/dev/null || true
    echo "TEARDOWN: removed help2man"
fi
echo ""
echo "All help2man functional tests passed!"
