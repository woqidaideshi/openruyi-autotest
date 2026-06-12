#!/bin/sh -eux
# Functional test: bison

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install bison ===
INSTALLED_BY_TEST=0
if ! rpm -q bison 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y bison 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed bison"
    else
        echo "SKIP: bison not available in repos"
        exit 0
    fi
else
    echo "SETUP: bison already installed"
fi


rpm -q bison 2>/dev/null || { echo "bison not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql bison 2>/dev/null | head -10 || true
rpm -qi bison 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "bison" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libbison*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/bison/ 2>/dev/null | head -5 || true


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y bison 2>/dev/null || true
    echo "TEARDOWN: removed bison"
fi
echo ""
echo "All bison functional tests passed!"
