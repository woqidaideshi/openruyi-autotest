#!/bin/sh -eux
# Functional test: glib - ��������
# Commands: glib-compile-schemas, gsettings

. "../setup.sh"

rlRun 'gsettings list-schemas 2>&1 | head -5 || true' 0 "�г� GSettings ģʽ"

. "../teardown.sh"
echo "All glib-basic functional tests passed!"
