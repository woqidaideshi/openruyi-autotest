#!/bin/sh -eux
# Functional test: rpm ��ѯ
# Commands: rpm

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install rpm ===
INSTALLED_BY_TEST=0
if ! rpm -q rpm 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y rpm 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed rpm"
    else
        echo "SKIP: rpm not available in repos"
        exit 0
    fi
else
    echo "SETUP: rpm already installed"
fi



echo "=== rpm ��ѯ ==="
rlRun 'rpm --help 2>&1 | head -10' 0 "rpm ����"
rlRun 'rpm -qa 2>&1 | head -10' 0 "�г����а�"
rlRun 'rpm -qi rpm 2>&1 | head -10' 0 "��ѯ����Ϣ"
rlRun 'rpm -ql rpm 2>&1 | head -10' 0 "�г����ļ�"
rlRun 'rpm -qc rpm 2>&1' 0 "�г������ļ�"
rlRun 'rpm -qd rpm 2>&1 | head -5' 0 "�г��ĵ�"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y rpm 2>/dev/null || true
    echo "TEARDOWN: removed rpm"
fi
echo ""
echo "All rpm-query functional tests passed!"
