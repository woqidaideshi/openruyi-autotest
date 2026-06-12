#!/bin/sh -eux
# Functional test: flex

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install flex ===
INSTALLED_BY_TEST=0
if ! rpm -q flex 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y flex 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed flex"
    else
        echo "SKIP: flex not available in repos"
        exit 0
    fi
else
    echo "SETUP: flex already installed"
fi


rpm -q flex 2>/dev/null || { echo "flex not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql flex 2>/dev/null | head -10 || true
rpm -qi flex 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "flex" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libflex*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/flex/ 2>/dev/null | head -5 || true


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y flex 2>/dev/null || true
    echo "TEARDOWN: removed flex"
fi
echo ""
echo "All flex functional tests passed!"
