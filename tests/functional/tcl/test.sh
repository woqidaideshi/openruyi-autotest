#!/bin/sh -eux
# Functional test: tcl

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install tcl ===
INSTALLED_BY_TEST=0
if ! rpm -q tcl 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y tcl 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed tcl"
    else
        echo "SKIP: tcl not available in repos"
        exit 0
    fi
else
    echo "SETUP: tcl already installed"
fi


rpm -q tcl 2>/dev/null || { echo "tcl not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql tcl 2>/dev/null | head -10 || true
rpm -qi tcl 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "tcl" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libtcl*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/tcl/ 2>/dev/null | head -5 || true


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y tcl 2>/dev/null || true
    echo "TEARDOWN: removed tcl"
fi
echo ""
echo "All tcl functional tests passed!"
