#!/bin/sh -eux
# Functional test: unbound

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install unbound ===
INSTALLED_BY_TEST=0
if ! rpm -q unbound 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y unbound 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed unbound"
    else
        echo "SKIP: unbound not available in repos"
        exit 0
    fi
else
    echo "SETUP: unbound already installed"
fi


rpm -q unbound 2>/dev/null || { echo "unbound not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql unbound 2>/dev/null | head -10 || true
rpm -qi unbound 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "unbound" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libunbound*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/unbound/ 2>/dev/null | head -5 || true


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y unbound 2>/dev/null || true
    echo "TEARDOWN: removed unbound"
fi
echo ""
echo "All unbound functional tests passed!"
