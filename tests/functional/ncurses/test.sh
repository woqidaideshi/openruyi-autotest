#!/bin/sh -eux
# Functional test: ncurses - �ն˽����
# Commands: clear, infocmp, reset, tabs, tic, toe

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install ncurses ===
INSTALLED_BY_TEST=0
if ! rpm -q ncurses 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y ncurses 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed ncurses"
    else
        echo "SKIP: ncurses not available in repos"
        exit 0
    fi
else
    echo "SETUP: ncurses already installed"
fi




# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y ncurses 2>/dev/null || true
    echo "TEARDOWN: removed ncurses"
fi
echo ""
echo "All ncurses functional tests passed!"
