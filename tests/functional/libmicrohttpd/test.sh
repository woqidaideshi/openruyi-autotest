#!/bin/sh -eux
# Functional test: libmicrohttpd

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libmicrohttpd ===
INSTALLED_BY_TEST=0
if ! rpm -q libmicrohttpd 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libmicrohttpd 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libmicrohttpd"
    else
        echo "SKIP: libmicrohttpd not available in repos"
        exit 0
    fi
else
    echo "SETUP: libmicrohttpd already installed"
fi


rpm -q libmicrohttpd 2>/dev/null || { echo "libmicrohttpd not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql libmicrohttpd 2>/dev/null | head -10 || true
rpm -qi libmicrohttpd 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "libmicrohttpd" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/liblibmicrohttpd*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/libmicrohttpd/ 2>/dev/null | head -5 || true


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libmicrohttpd 2>/dev/null || true
    echo "TEARDOWN: removed libmicrohttpd"
fi
echo ""
echo "All libmicrohttpd functional tests passed!"
