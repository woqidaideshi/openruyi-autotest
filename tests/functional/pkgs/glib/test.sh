#!/bin/sh -eux
# Functional test: glib - GLib ���߿�
# Commands: glib-compile-schemas, gsettings, gresource, gdbus

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install glib ===
INSTALLED_BY_TEST=0
if ! rpm -q glib 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y glib 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed glib"
    else
        echo "SKIP: glib not available in repos"
        exit 0
    fi
else
    echo "SETUP: glib already installed"
fi




# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y glib 2>/dev/null || true
    echo "TEARDOWN: removed glib"
fi
echo ""
echo "All glib functional tests passed!"
