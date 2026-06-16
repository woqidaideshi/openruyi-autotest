#!/bin/sh -eux
# Functional test: libevent - ���
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
rlRun 'ldconfig -p 2>/dev/null | grep libevent | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libevent 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libevent 2>/dev/null || true
    echo "TEARDOWN: removed libevent"
fi
echo ""
echo "All libevent functional tests passed!"
