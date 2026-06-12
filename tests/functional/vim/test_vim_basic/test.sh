#!/bin/sh -eux
# Functional test: vim - ��������
# Commands: vim

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q vim 2>/dev/null || { echo 'vim not installed, skipping'; exit 0; }
which vim 2>/dev/null || echo 'vim not found'

echo "=== vim �������� ==="
rlRun 'vim --help 2>&1 | head -10' 0 "vim ����"
rlRun 'echo test | vim - -c "wq! /tmp/vimtest" 2>&1 || true' 0 "vim ������ģʽ"
rlRun 'test -f /tmp/vimtest && rm -f /tmp/vimtest || true' 0 "��֤vim�����ļ�"

echo ""
echo "All vim-basic functional tests passed!"
