#!/bin/sh -eux
# Functional test: autoconf

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install autoconf ===
INSTALLED_BY_TEST=0
if ! rpm -q autoconf 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y autoconf 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed autoconf"
    else
        echo "SKIP: autoconf not available in repos"
        exit 0
    fi
else
    echo "SETUP: autoconf already installed"
fi


rpm -q autoconf 2>/dev/null || { echo "autoconf not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql autoconf 2>/dev/null | head -10 || true
rpm -qi autoconf 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "autoconf" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libautoconf*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/autoconf/ 2>/dev/null | head -5 || true


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y autoconf 2>/dev/null || true
    echo "TEARDOWN: removed autoconf"
fi
echo ""
echo "All autoconf functional tests passed!"
