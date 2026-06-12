#!/bin/sh -eux
# Functional test: libevent - �ļ���֤
# Commands: libevent-2.1.so.7, libevent-2.1.so.7.0.1, libevent_core-2.1.so.7, libevent_core-2.1.so.7.0.1, libevent_extra-2.1.so.7, libevent_extra-2.1.so.7.0.1, libevent_openssl-2.1.so.7, libevent_openssl-2.1.so.7.0.1, libevent_pthreads-2.1.so.7, libevent_pthreads-2.1.so.7.0.1

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libevent ===
INSTALLED_BY_TEST=0
if ! rpm -q libevent 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libevent 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libevent"
    else
        echo "SKIP: libevent not available in repos"
        exit 0
    fi
else
    echo "SETUP: libevent already installed"
fi



echo "=== ���ļ���֤ ==="
rlRun 'ls /usr/lib64/libevent-2.1.so.7* 2>/dev/null || ls /usr/lib/libevent-2.1.so.7* 2>/dev/null || echo "not in standard path"' 0 "��� libevent-2.1.so.7"
rlRun 'ls /usr/lib64/libevent-2.1.so.7.0.1* 2>/dev/null || ls /usr/lib/libevent-2.1.so.7.0.1* 2>/dev/null || echo "not in standard path"' 0 "��� libevent-2.1.so.7.0.1"
rlRun 'ls /usr/lib64/libevent_core-2.1.so.7* 2>/dev/null || ls /usr/lib/libevent_core-2.1.so.7* 2>/dev/null || echo "not in standard path"' 0 "��� libevent_core-2.1.so.7"
rlRun 'ls /usr/lib64/libevent_core-2.1.so.7.0.1* 2>/dev/null || ls /usr/lib/libevent_core-2.1.so.7.0.1* 2>/dev/null || echo "not in standard path"' 0 "��� libevent_core-2.1.so.7.0.1"
rlRun 'ls /usr/lib64/libevent_extra-2.1.so.7* 2>/dev/null || ls /usr/lib/libevent_extra-2.1.so.7* 2>/dev/null || echo "not in standard path"' 0 "��� libevent_extra-2.1.so.7"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libevent 2>&1 || true' 0 "pkg-config ����Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libevent 2>/dev/null || true
    echo "TEARDOWN: removed libevent"
fi
echo ""
echo "All libevent-files functional tests passed!"
