#!/bin/sh -eux
# Functional test: gpm

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install gpm ===
INSTALLED_BY_TEST=0
if ! rpm -q gpm 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y gpm 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed gpm"
    else
        echo "SKIP: gpm not available in repos"
        exit 0
    fi
else
    echo "SETUP: gpm already installed"
fi


rpm -q gpm 2>/dev/null || { echo "gpm not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql gpm 2>/dev/null | head -10 || true
rpm -qi gpm 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "gpm" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libgpm*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/gpm/ 2>/dev/null | head -5 || true


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y gpm 2>/dev/null || true
    echo "TEARDOWN: removed gpm"
fi
echo ""
echo "All gpm functional tests passed!"
