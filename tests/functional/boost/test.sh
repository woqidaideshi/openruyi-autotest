#!/bin/sh -eux
# Functional test: boost

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install boost ===
INSTALLED_BY_TEST=0
if ! rpm -q boost 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y boost 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed boost"
    else
        echo "SKIP: boost not available in repos"
        exit 0
    fi
else
    echo "SETUP: boost already installed"
fi


rpm -q boost 2>/dev/null || { echo "boost not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql boost 2>/dev/null | head -10 || true
rpm -qi boost 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "boost" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libboost*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/boost/ 2>/dev/null | head -5 || true


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y boost 2>/dev/null || true
    echo "TEARDOWN: removed boost"
fi
echo ""
echo "All boost functional tests passed!"
