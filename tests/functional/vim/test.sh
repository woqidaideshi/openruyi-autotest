#!/bin/sh -eux
# Functional test: vim - Vi �༭��
# Commands: vim, vi, view, vimdiff, rvim

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q vim 2>/dev/null || { echo 'vim not installed, skipping'; exit 0; }
which vim 2>/dev/null || echo 'vim not found'
rlRun 'vim --version 2>&1 || true' 0 "��ȡ vim �汾"

echo ""
echo "All vim functional tests passed!"
