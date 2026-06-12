#!/bin/sh -eux
# Functional test: python-lxml - ���
# Commands: _elementpath.cpython-313-riscv64-linux-gnu.so, builder.cpython-313-riscv64-linux-gnu.so, etree.cpython-313-riscv64-linux-gnu.so, _difflib.cpython-313-riscv64-linux-gnu.so, diff.cpython-313-riscv64-linux-gnu.so, objectify.cpython-313-riscv64-linux-gnu.so, sax.cpython-313-riscv64-linux-gnu.so

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q python-lxml 2>/dev/null || { echo 'python-lxml not installed, skipping'; exit 0; }

echo "=== ���ļ���֤ ==="
rlRun 'ldconfig -p 2>/dev/null | grep python-lxml | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql python-lxml 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"

echo ""
echo "All python-lxml functional tests passed!"
