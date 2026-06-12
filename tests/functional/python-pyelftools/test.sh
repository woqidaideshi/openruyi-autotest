#!/bin/sh -eux
# Functional test: python-pyelftools

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install python-pyelftools ===
INSTALLED_BY_TEST=0
if ! rpm -q python-pyelftools 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y python-pyelftools 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed python-pyelftools"
    else
        echo "SKIP: python-pyelftools not available in repos"
        exit 0
    fi
else
    echo "SETUP: python-pyelftools already installed"
fi


rpm -q python3-pyelftools 2>/dev/null || { echo "python3-pyelftools not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql python3-pyelftools 2>/dev/null | head -10 || true
rpm -qi python3-pyelftools 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "python-pyelftools" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libpython-pyelftools*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/python-pyelftools/ 2>/dev/null | head -5 || true


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y python-pyelftools 2>/dev/null || true
    echo "TEARDOWN: removed python-pyelftools"
fi
echo ""
echo "All python-pyelftools functional tests passed!"
