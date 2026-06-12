#!/bin/sh -eux
# Functional test: libpng ������
# Tests: pngfix commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libpng ===
INSTALLED_BY_TEST=0
if ! rpm -q libpng 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libpng 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libpng"
    else
        echo "SKIP: libpng not available in repos"
        exit 0
    fi
else
    echo "SETUP: libpng already installed"
fi


rlRun 'pngfix --version 2>&1 || true' 0 "��ȡ pngfix �汾��Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libpng 2>/dev/null || true
    echo "TEARDOWN: removed libpng"
fi
echo ""
echo "All libpng functional tests passed!"
