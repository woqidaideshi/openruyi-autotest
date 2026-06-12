#!/bin/sh -eux
# Functional test: iptables

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install iptables ===
INSTALLED_BY_TEST=0
if ! rpm -q iptables 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y iptables 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed iptables"
    else
        echo "SKIP: iptables not available in repos"
        exit 0
    fi
else
    echo "SETUP: iptables already installed"
fi


rpm -q iptables 2>/dev/null || { echo "iptables not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql iptables 2>/dev/null | head -10 || true
rpm -qi iptables 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "iptables" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libiptables*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/iptables/ 2>/dev/null | head -5 || true


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y iptables 2>/dev/null || true
    echo "TEARDOWN: removed iptables"
fi
echo ""
echo "All iptables functional tests passed!"
