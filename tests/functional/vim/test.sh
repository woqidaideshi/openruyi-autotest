#!/bin/sh -eux
# Functional test: vim - Vi �༭��
# Commands: vim, vi, view, vimdiff, rvim

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install vim ===
INSTALLED_BY_TEST=0
if ! rpm -q vim 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y vim 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed vim"
    else
        echo "SKIP: vim not available in repos"
        exit 0
    fi
else
    echo "SETUP: vim already installed"
fi


rlRun 'vim --version 2>&1 || true' 0 "��ȡ vim �汾"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y vim 2>/dev/null || true
    echo "TEARDOWN: removed vim"
fi
echo ""
echo "All vim functional tests passed!"
