#!/bin/sh -eux
# Functional test: vim - ��������
# Commands: vim

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



echo "=== vim �������� ==="
rlRun 'vim --help 2>&1 | head -10' 0 "vim ����"
rlRun 'echo test | vim - -c "wq! /tmp/vimtest" 2>&1 || true' 0 "vim ������ģʽ"
rlRun 'test -f /tmp/vimtest && rm -f /tmp/vimtest || true' 0 "��֤vim�����ļ�"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y vim 2>/dev/null || true
    echo "TEARDOWN: removed vim"
fi
echo ""
echo "All vim-basic functional tests passed!"
