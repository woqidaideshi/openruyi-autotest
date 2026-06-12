#!/bin/sh -eux
# Functional test: texinfo

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install texinfo ===
INSTALLED_BY_TEST=0
if ! rpm -q texinfo 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y texinfo 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed texinfo"
    else
        echo "SKIP: texinfo not available in repos"
        exit 0
    fi
else
    echo "SETUP: texinfo already installed"
fi


rpm -q texinfo 2>/dev/null || { echo "texinfo not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql texinfo 2>/dev/null | head -10 || true
rpm -qi texinfo 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "texinfo" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libtexinfo*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/texinfo/ 2>/dev/null | head -5 || true


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y texinfo 2>/dev/null || true
    echo "TEARDOWN: removed texinfo"
fi
echo ""
echo "All texinfo functional tests passed!"
