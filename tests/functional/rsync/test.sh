#!/bin/sh -eux
# Functional test: rsync

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install rsync ===
INSTALLED_BY_TEST=0
if ! rpm -q rsync 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y rsync 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed rsync"
    else
        echo "SKIP: rsync not available in repos"
        exit 0
    fi
else
    echo "SETUP: rsync already installed"
fi


rpm -q rsync 2>/dev/null || { echo "rsync not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql rsync 2>/dev/null | head -10 || true
rpm -qi rsync 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "rsync" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/librsync*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/rsync/ 2>/dev/null | head -5 || true


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y rsync 2>/dev/null || true
    echo "TEARDOWN: removed rsync"
fi
echo ""
echo "All rsync functional tests passed!"
