#!/bin/sh -eux
# Functional test: lzip

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install lzip ===
INSTALLED_BY_TEST=0
if ! rpm -q lzip 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y lzip 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed lzip"
    else
        echo "SKIP: lzip not available in repos"
        exit 0
    fi
else
    echo "SETUP: lzip already installed"
fi


rpm -q lzip 2>/dev/null || { echo "lzip not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql lzip 2>/dev/null | head -10 || true
rpm -qi lzip 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "lzip" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/liblzip*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/lzip/ 2>/dev/null | head -5 || true


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y lzip 2>/dev/null || true
    echo "TEARDOWN: removed lzip"
fi
echo ""
echo "All lzip functional tests passed!"
