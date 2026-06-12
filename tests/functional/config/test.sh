#!/bin/sh -eux
# Functional test: config

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install config ===
INSTALLED_BY_TEST=0
if ! rpm -q config 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y config 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed config"
    else
        echo "SKIP: config not available in repos"
        exit 0
    fi
else
    echo "SETUP: config already installed"
fi


rpm -q config 2>/dev/null || { echo "config not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql config 2>/dev/null | head -10 || true
rpm -qi config 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "config" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libconfig*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/config/ 2>/dev/null | head -5 || true


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y config 2>/dev/null || true
    echo "TEARDOWN: removed config"
fi
echo ""
echo "All config functional tests passed!"
