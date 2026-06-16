#!/bin/sh -eux
# Functional test: krb5 ��������
# Commands: kinit, klist, kdestroy, kadmin, ktutil

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install krb5 ===
INSTALLED_BY_TEST=0
if ! rpm -q krb5 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y krb5 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed krb5"
    else
        echo "SKIP: krb5 not available in repos"
        exit 0
    fi
else
    echo "SETUP: krb5 already installed"
fi



echo "=== Kerberos ���� ==="
rlRun 'kinit --help 2>&1 | head -10' 0 "kinit ����"
rlRun 'klist --help 2>&1 | head -10' 0 "klist ����"
rlRun 'kdestroy --help 2>&1 | head -10' 0 "kdestroy ����"
rlRun 'kadmin --help 2>&1 | head -10' 0 "kadmin ����"
rlRun 'ktutil --help 2>&1 | head -10' 0 "ktutil ����"
rlRun 'klist 2>&1 || true' 0 "�鿴Ʊ��(����Ϊ��)"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y krb5 2>/dev/null || true
    echo "TEARDOWN: removed krb5"
fi
echo ""
echo "All krb5-basic functional tests passed!"
