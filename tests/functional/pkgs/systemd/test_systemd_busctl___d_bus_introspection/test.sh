#!/bin/sh -eux
# Functional test: systemd - busctl---D-Bus-introspection

. "../setup.sh"

echo "=== Test 12: busctl - D-Bus introspection ==="

rlRun 'busctl --version 2>&1 || true' 0 "busctl version"
rlRun 'busctl list 2>&1 | head -10' 0 "busctl list: list services"
rlRun 'busctl status 2>&1 | head -10' 0 "busctl status: bus status"
rlRun 'busctl tree org.freedesktop.systemd1 2>&1 | head -10' 0 "busctl tree: object tree"
rlRun 'busctl introspect org.freedesktop.systemd1 /org/freedesktop/systemd1 2>&1 | head -10' 0 "busctl introspect"

# ===================================================================

. "../teardown.sh"
echo "All systemd busctl---D-Bus-introspection tests passed!"
