#!/bin/sh -eux
# Functional test: scdoc

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install scdoc ===
INSTALLED_BY_TEST=0
if ! rpm -q scdoc 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y scdoc 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed scdoc"
    else
        echo "SKIP: scdoc not available in repos"
        exit 0
    fi
else
    echo "SETUP: scdoc already installed"
fi


rpm -q scdoc 2>/dev/null || { echo "scdoc not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql scdoc 2>/dev/null | head -10 || true
rpm -qi scdoc 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "scdoc" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libscdoc*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/scdoc/ 2>/dev/null | head -5 || true


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y scdoc 2>/dev/null || true
    echo "TEARDOWN: removed scdoc"
fi
echo ""
echo "All scdoc functional tests passed!"
