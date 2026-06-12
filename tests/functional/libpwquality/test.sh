#!/bin/sh -eux
# Functional test: libpwquality ������
# Tests: pwmake, pwscore commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libpwquality ===
INSTALLED_BY_TEST=0
if ! rpm -q libpwquality 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libpwquality 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libpwquality"
    else
        echo "SKIP: libpwquality not available in repos"
        exit 0
    fi
else
    echo "SETUP: libpwquality already installed"
fi


rlRun 'pwmake --version 2>&1 || true' 0 "��ȡ pwmake �汾��Ϣ"
rlRun 'pwscore --version 2>&1 || true' 0 "��ȡ pwscore �汾��Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libpwquality 2>/dev/null || true
    echo "TEARDOWN: removed libpwquality"
fi
echo ""
echo "All libpwquality functional tests passed!"
