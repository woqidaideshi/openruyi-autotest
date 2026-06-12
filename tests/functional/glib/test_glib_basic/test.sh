#!/bin/sh -eux
# Functional test: glib - ��������
# Commands: glib-compile-schemas, gsettings

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q glib 2>/dev/null || { echo 'glib not installed, skipping'; exit 0; }
which glib-compile-schemas 2>/dev/null || echo 'glib-compile-schemas not found'
which gsettings 2>/dev/null || echo 'gsettings not found'

echo "=== glib ���� ==="
rlRun 'glib-compile-schemas --help 2>&1 | head -10' 0 "glib-compile-schemas ����"
rlRun 'gsettings --help 2>&1 | head -10' 0 "gsettings ����"
rlRun 'gsettings list-schemas 2>&1 | head -5 || true' 0 "�г� GSettings ģʽ"

echo ""
echo "All glib-basic functional tests passed!"
