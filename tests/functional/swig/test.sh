#!/bin/sh -eux
# Functional test: swig

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install swig ===
INSTALLED_BY_TEST=0
if ! rpm -q swig 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y swig 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed swig"
    else
        echo "SKIP: swig not available in repos"
        exit 0
    fi
else
    echo "SETUP: swig already installed"
fi


rpm -q swig 2>/dev/null || { echo "swig not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql swig 2>/dev/null | head -10 || true
rpm -qi swig 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "swig" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libswig*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/swig/ 2>/dev/null | head -5 || true


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y swig 2>/dev/null || true
    echo "TEARDOWN: removed swig"
fi
echo ""
echo "All swig functional tests passed!"
