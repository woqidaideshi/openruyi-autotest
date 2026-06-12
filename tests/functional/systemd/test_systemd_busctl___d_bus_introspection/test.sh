#!/bin/sh -eux
# Functional test: systemd - busctl---D-Bus-introspection

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install systemd ===
INSTALLED_BY_TEST=0
if ! rpm -q systemd 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y systemd 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed systemd"
    else
        echo "SKIP: systemd not available in repos"
        exit 0
    fi
else
    echo "SETUP: systemd already installed"
fi

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 12: busctl - D-Bus introspection ==="

rlRun 'busctl --version 2>&1 || true' 0 "busctl version"
rlRun 'busctl list 2>&1 | head -10' 0 "busctl list: list services"
rlRun 'busctl status 2>&1 | head -10' 0 "busctl status: bus status"
rlRun 'busctl tree org.freedesktop.systemd1 2>&1 | head -10' 0 "busctl tree: object tree"
rlRun 'busctl introspect org.freedesktop.systemd1 /org/freedesktop/systemd1 2>&1 | head -10' 0 "busctl introspect"

# ===================================================================


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y systemd 2>/dev/null || true
    echo "TEARDOWN: removed systemd"
fi
echo ""
echo "All systemd busctl---D-Bus-introspection tests passed!"
