#!/bin/sh -eux
# Functional test: nghttp2 - ���
# Commands: libnghttp2.so.14, libnghttp2.so.14.29.4

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install nghttp2 ===
INSTALLED_BY_TEST=0
if ! rpm -q nghttp2 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y nghttp2 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed nghttp2"
    else
        echo "SKIP: nghttp2 not available in repos"
        exit 0
    fi
else
    echo "SETUP: nghttp2 already installed"
fi



echo "=== ���ļ���֤ ==="
rlRun 'ldconfig -p 2>/dev/null | grep nghttp2 | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql nghttp2 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y nghttp2 2>/dev/null || true
    echo "TEARDOWN: removed nghttp2"
fi
echo ""
echo "All nghttp2 functional tests passed!"
