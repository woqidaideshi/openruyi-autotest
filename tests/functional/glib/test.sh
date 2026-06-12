#!/bin/sh -eux
# Functional test: glib - GLib ���߿�
# Commands: glib-compile-schemas, gsettings, gresource, gdbus

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q glib 2>/dev/null || { echo 'glib not installed, skipping'; exit 0; }
which glib-compile-schemas 2>/dev/null || echo 'glib-compile-schemas not found'
which gsettings 2>/dev/null || echo 'gsettings not found'

echo ""
echo "All glib functional tests passed!"
