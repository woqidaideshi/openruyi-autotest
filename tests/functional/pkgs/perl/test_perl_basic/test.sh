#!/bin/sh -eux
# Functional test: perl - ��������
# Commands: perl

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install perl ===
INSTALLED_BY_TEST=0
if ! rpm -q perl 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y perl 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed perl"
    else
        echo "SKIP: perl not available in repos"
        exit 0
    fi
else
    echo "SETUP: perl already installed"
fi



echo "=== perl �������� ==="
rlRun 'perl --help 2>&1 | head -10' 0 "perl ����"
rlRun 'perl -e "print \"hello\n\""' 0 "ִ�м� Perl ����"
rlRun 'perl -v 2>&1 | head -5' 0 "�鿴�汾����"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y perl 2>/dev/null || true
    echo "TEARDOWN: removed perl"
fi
echo ""
echo "All perl-basic functional tests passed!"
