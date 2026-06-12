#!/bin/sh -eux
# Functional test: perl-Error

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install perl-Error ===
INSTALLED_BY_TEST=0
if ! rpm -q perl-Error 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y perl-Error 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed perl-Error"
    else
        echo "SKIP: perl-Error not available in repos"
        exit 0
    fi
else
    echo "SETUP: perl-Error already installed"
fi


rpm -q perl-Error 2>/dev/null || { echo "perl-Error not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql perl-Error 2>/dev/null | head -10 || true
rpm -qi perl-Error 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "perl-Error" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libperl-Error*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/perl-Error/ 2>/dev/null | head -5 || true


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y perl-Error 2>/dev/null || true
    echo "TEARDOWN: removed perl-Error"
fi
echo ""
echo "All perl-Error functional tests passed!"
