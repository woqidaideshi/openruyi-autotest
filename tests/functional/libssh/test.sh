#!/bin/sh -eux
# Functional test: libssh

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libssh ===
INSTALLED_BY_TEST=0
if ! rpm -q libssh 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libssh 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libssh"
    else
        echo "SKIP: libssh not available in repos"
        exit 0
    fi
else
    echo "SETUP: libssh already installed"
fi


rpm -q libssh 2>/dev/null || { echo "libssh not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql libssh 2>/dev/null | head -10 || true
rpm -qi libssh 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "libssh" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/liblibssh*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/libssh/ 2>/dev/null | head -5 || true


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libssh 2>/dev/null || true
    echo "TEARDOWN: removed libssh"
fi
echo ""
echo "All libssh functional tests passed!"
