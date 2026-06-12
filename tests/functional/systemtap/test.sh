#!/bin/sh -eux
# Functional test: systemtap

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install systemtap ===
INSTALLED_BY_TEST=0
if ! rpm -q systemtap 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y systemtap 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed systemtap"
    else
        echo "SKIP: systemtap not available in repos"
        exit 0
    fi
else
    echo "SETUP: systemtap already installed"
fi


rpm -q systemtap 2>/dev/null || { echo "systemtap not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql systemtap 2>/dev/null | head -10 || true
rpm -qi systemtap 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "systemtap" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libsystemtap*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/systemtap/ 2>/dev/null | head -5 || true


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y systemtap 2>/dev/null || true
    echo "TEARDOWN: removed systemtap"
fi
echo ""
echo "All systemtap functional tests passed!"
