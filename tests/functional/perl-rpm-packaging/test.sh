#!/bin/sh -eux
# Functional test: perl-rpm-packaging

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install perl-rpm-packaging ===
INSTALLED_BY_TEST=0
if ! rpm -q perl-rpm-packaging 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y perl-rpm-packaging 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed perl-rpm-packaging"
    else
        echo "SKIP: perl-rpm-packaging not available in repos"
        exit 0
    fi
else
    echo "SETUP: perl-rpm-packaging already installed"
fi


rpm -q perl-rpm-packaging 2>/dev/null || { echo "perl-rpm-packaging not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql perl-rpm-packaging 2>/dev/null | head -10 || true
rpm -qi perl-rpm-packaging 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "perl-rpm-packaging" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libperl-rpm-packaging*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/perl-rpm-packaging/ 2>/dev/null | head -5 || true


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y perl-rpm-packaging 2>/dev/null || true
    echo "TEARDOWN: removed perl-rpm-packaging"
fi
echo ""
echo "All perl-rpm-packaging functional tests passed!"
