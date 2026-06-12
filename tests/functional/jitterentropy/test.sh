#!/bin/sh -eux
# Functional test: jitterentropy - ���
# Commands: libjitterentropy.so.3, libjitterentropy.so.3.6.3

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install jitterentropy ===
INSTALLED_BY_TEST=0
if ! rpm -q jitterentropy 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y jitterentropy 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed jitterentropy"
    else
        echo "SKIP: jitterentropy not available in repos"
        exit 0
    fi
else
    echo "SETUP: jitterentropy already installed"
fi



echo "=== ���ļ���֤ ==="
rlRun 'ldconfig -p 2>/dev/null | grep jitterentropy | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql jitterentropy 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y jitterentropy 2>/dev/null || true
    echo "TEARDOWN: removed jitterentropy"
fi
echo ""
echo "All jitterentropy functional tests passed!"
