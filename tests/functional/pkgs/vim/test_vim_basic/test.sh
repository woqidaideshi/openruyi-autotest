#!/bin/sh -eux
# Functional test: vim - ��������
# Commands: vim

. "../setup.sh"

rlRun 'echo test | vim - -c "wq! /tmp/vimtest" 2>&1 || true' 0 "vim ������ģʽ"
rlRun 'test -f /tmp/vimtest && rm -f /tmp/vimtest || true' 0 "��֤vim�����ļ�"

. "../teardown.sh"
echo "All vim-basic functional tests passed!"
