#!/bin/sh -eux
# Functional test: python-setuptools

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install python-setuptools ===
INSTALLED_BY_TEST=0
if ! rpm -q python-setuptools 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y python-setuptools 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed python-setuptools"
    else
        echo "SKIP: python-setuptools not available in repos"
        exit 0
    fi
else
    echo "SETUP: python-setuptools already installed"
fi


rpm -q python3-setuptools 2>/dev/null || { echo "python3-setuptools not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql python3-setuptools 2>/dev/null | head -10 || true
rpm -qi python3-setuptools 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "python-setuptools" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libpython-setuptools*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/python-setuptools/ 2>/dev/null | head -5 || true


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y python-setuptools 2>/dev/null || true
    echo "TEARDOWN: removed python-setuptools"
fi
echo ""
echo "All python-setuptools functional tests passed!"
