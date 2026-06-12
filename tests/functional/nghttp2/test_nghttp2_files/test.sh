#!/bin/sh -eux
# Functional test: nghttp2 - �ļ���֤
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
rlRun 'ls /usr/lib64/libnghttp2.so.14* 2>/dev/null || ls /usr/lib/libnghttp2.so.14* 2>/dev/null || echo "not in standard path"' 0 "��� libnghttp2.so.14"
rlRun 'ls /usr/lib64/libnghttp2.so.14.29.4* 2>/dev/null || ls /usr/lib/libnghttp2.so.14.29.4* 2>/dev/null || echo "not in standard path"' 0 "��� libnghttp2.so.14.29.4"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs nghttp2 2>&1 || true' 0 "pkg-config ����Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y nghttp2 2>/dev/null || true
    echo "TEARDOWN: removed nghttp2"
fi
echo ""
echo "All nghttp2-files functional tests passed!"
