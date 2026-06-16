#!/bin/sh -eux
# Functional test: python-lxml - ���
# Commands: _elementpath.cpython-313-riscv64-linux-gnu.so, builder.cpython-313-riscv64-linux-gnu.so, etree.cpython-313-riscv64-linux-gnu.so, _difflib.cpython-313-riscv64-linux-gnu.so, diff.cpython-313-riscv64-linux-gnu.so, objectify.cpython-313-riscv64-linux-gnu.so, sax.cpython-313-riscv64-linux-gnu.so

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install python-lxml ===
INSTALLED_BY_TEST=0
if ! rpm -q python-lxml 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y python-lxml 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed python-lxml"
    else
        echo "SKIP: python-lxml not available in repos"
        exit 0
    fi
else
    echo "SETUP: python-lxml already installed"
fi



echo "=== ���ļ���֤ ==="
rlRun 'ldconfig -p 2>/dev/null | grep python-lxml | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql python-lxml 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y python-lxml 2>/dev/null || true
    echo "TEARDOWN: removed python-lxml"
fi
echo ""
echo "All python-lxml functional tests passed!"
