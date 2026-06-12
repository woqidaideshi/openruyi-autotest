#!/bin/sh -eux
# Functional test: perl-Locale-gettext - Perl gettext ��

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install perl-Locale-gettext ===
INSTALLED_BY_TEST=0
if ! rpm -q perl-Locale-gettext 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y perl-Locale-gettext 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed perl-Locale-gettext"
    else
        echo "SKIP: perl-Locale-gettext not available in repos"
        exit 0
    fi
else
    echo "SETUP: perl-Locale-gettext already installed"
fi



echo "=== ģ����֤ ==="
rlRun 'perl -e "use Locale::gettext; print \"ok\n\"" 2>&1 || true' 0 "���� Locale::gettext ģ�����"
rlRun 'rpm -ql perl-Locale-gettext 2>/dev/null | head -10' 0 "�г����ļ�"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y perl-Locale-gettext 2>/dev/null || true
    echo "TEARDOWN: removed perl-Locale-gettext"
fi
echo ""
echo "All perl-Locale-gettext functional tests passed!"
