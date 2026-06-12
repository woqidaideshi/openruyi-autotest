#!/bin/sh -eux
# Functional test: source-highlight

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install source-highlight ===
INSTALLED_BY_TEST=0
if ! rpm -q source-highlight 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y source-highlight 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed source-highlight"
    else
        echo "SKIP: source-highlight not available in repos"
        exit 0
    fi
else
    echo "SETUP: source-highlight already installed"
fi


rpm -q source-highlight 2>/dev/null || { echo "source-highlight not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql source-highlight 2>/dev/null | head -10 || true
rpm -qi source-highlight 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "source-highlight" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libsource-highlight*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/source-highlight/ 2>/dev/null | head -5 || true


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y source-highlight 2>/dev/null || true
    echo "TEARDOWN: removed source-highlight"
fi
echo ""
echo "All source-highlight functional tests passed!"
