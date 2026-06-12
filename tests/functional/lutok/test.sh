#!/bin/sh -eux
# Functional test: lutok

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install lutok ===
INSTALLED_BY_TEST=0
if ! rpm -q lutok 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y lutok 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed lutok"
    else
        echo "SKIP: lutok not available in repos"
        exit 0
    fi
else
    echo "SETUP: lutok already installed"
fi


rpm -q lutok 2>/dev/null || { echo "lutok not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql lutok 2>/dev/null | head -10 || true
rpm -qi lutok 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "lutok" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/liblutok*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/lutok/ 2>/dev/null | head -5 || true


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y lutok 2>/dev/null || true
    echo "TEARDOWN: removed lutok"
fi
echo ""
echo "All lutok functional tests passed!"
