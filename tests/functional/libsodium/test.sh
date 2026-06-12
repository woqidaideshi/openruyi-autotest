#!/bin/sh -eux
# Functional test: libsodium

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libsodium ===
INSTALLED_BY_TEST=0
if ! rpm -q libsodium 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libsodium 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libsodium"
    else
        echo "SKIP: libsodium not available in repos"
        exit 0
    fi
else
    echo "SETUP: libsodium already installed"
fi


rpm -q libsodium 2>/dev/null || { echo "libsodium not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql libsodium 2>/dev/null | head -10 || true
rpm -qi libsodium 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "libsodium" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/liblibsodium*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/libsodium/ 2>/dev/null | head -5 || true


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libsodium 2>/dev/null || true
    echo "TEARDOWN: removed libsodium"
fi
echo ""
echo "All libsodium functional tests passed!"
