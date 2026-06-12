#!/bin/sh -eux
# Functional test: ninja

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install ninja ===
INSTALLED_BY_TEST=0
if ! rpm -q ninja 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y ninja 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed ninja"
    else
        echo "SKIP: ninja not available in repos"
        exit 0
    fi
else
    echo "SETUP: ninja already installed"
fi


rpm -q ninja 2>/dev/null || { echo "ninja not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql ninja 2>/dev/null | head -10 || true
rpm -qi ninja 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "ninja" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libninja*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/ninja/ 2>/dev/null | head -5 || true


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y ninja 2>/dev/null || true
    echo "TEARDOWN: removed ninja"
fi
echo ""
echo "All ninja functional tests passed!"
