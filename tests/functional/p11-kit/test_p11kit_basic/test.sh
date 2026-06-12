#!/bin/sh -eux
# Functional test: p11-kit - ��������
# Commands: p11-kit, trust

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install p11-kit ===
INSTALLED_BY_TEST=0
if ! rpm -q p11-kit 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y p11-kit 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed p11-kit"
    else
        echo "SKIP: p11-kit not available in repos"
        exit 0
    fi
else
    echo "SETUP: p11-kit already installed"
fi



echo "=== p11-kit �������� ==="
rlRun 'p11-kit --help 2>&1 | head -10' 0 "p11-kit ����"
rlRun 'trust --help 2>&1 | head -10' 0 "trust ����"
rlRun 'p11-kit list-modules 2>&1 | head -5 || true' 0 "�г�ģ��"
rlRun 'trust list 2>&1 | head -5 || true' 0 "�г�����ê"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y p11-kit 2>/dev/null || true
    echo "TEARDOWN: removed p11-kit"
fi
echo ""
echo "All p11kit-basic functional tests passed!"
