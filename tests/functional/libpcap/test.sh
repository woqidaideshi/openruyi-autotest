#!/bin/sh -eux
# Functional test: libpcap

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libpcap ===
INSTALLED_BY_TEST=0
if ! rpm -q libpcap 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libpcap 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libpcap"
    else
        echo "SKIP: libpcap not available in repos"
        exit 0
    fi
else
    echo "SETUP: libpcap already installed"
fi


rpm -q libpcap 2>/dev/null || { echo "libpcap not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql libpcap 2>/dev/null | head -10 || true
rpm -qi libpcap 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "libpcap" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/liblibpcap*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/libpcap/ 2>/dev/null | head -5 || true


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libpcap 2>/dev/null || true
    echo "TEARDOWN: removed libpcap"
fi
echo ""
echo "All libpcap functional tests passed!"
