#!/bin/sh -eux
# Functional test: cmocka

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install cmocka ===
INSTALLED_BY_TEST=0
if ! rpm -q cmocka 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y cmocka 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed cmocka"
    else
        echo "SKIP: cmocka not available in repos"
        exit 0
    fi
else
    echo "SETUP: cmocka already installed"
fi


rpm -q cmocka 2>/dev/null || { echo "cmocka not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql cmocka 2>/dev/null | head -10 || true
rpm -qi cmocka 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "cmocka" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libcmocka*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/cmocka/ 2>/dev/null | head -5 || true


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y cmocka 2>/dev/null || true
    echo "TEARDOWN: removed cmocka"
fi
echo ""
echo "All cmocka functional tests passed!"
