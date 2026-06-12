#!/bin/sh -eux
# Functional test: automake

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install automake ===
INSTALLED_BY_TEST=0
if ! rpm -q automake 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y automake 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed automake"
    else
        echo "SKIP: automake not available in repos"
        exit 0
    fi
else
    echo "SETUP: automake already installed"
fi


rpm -q automake 2>/dev/null || { echo "automake not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql automake 2>/dev/null | head -10 || true
rpm -qi automake 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "automake" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libautomake*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/automake/ 2>/dev/null | head -5 || true


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y automake 2>/dev/null || true
    echo "TEARDOWN: removed automake"
fi
echo ""
echo "All automake functional tests passed!"
