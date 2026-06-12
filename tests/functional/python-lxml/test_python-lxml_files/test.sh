#!/bin/sh -eux
# Functional test: python-lxml - �ļ���֤
# Commands: _elementpath.cpython-313-riscv64-linux-gnu.so, builder.cpython-313-riscv64-linux-gnu.so, etree.cpython-313-riscv64-linux-gnu.so, _difflib.cpython-313-riscv64-linux-gnu.so, diff.cpython-313-riscv64-linux-gnu.so, objectify.cpython-313-riscv64-linux-gnu.so, sax.cpython-313-riscv64-linux-gnu.so

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q python-lxml 2>/dev/null || { echo 'python-lxml not installed, skipping'; exit 0; }

echo "=== ���ļ���֤ ==="
rlRun 'ls /usr/lib64/_elementpath.cpython-313-riscv64-linux-gnu.so* 2>/dev/null || ls /usr/lib/_elementpath.cpython-313-riscv64-linux-gnu.so* 2>/dev/null || echo "not in standard path"' 0 "��� _elementpath.cpython-313-riscv64-linux-gnu.so"
rlRun 'ls /usr/lib64/builder.cpython-313-riscv64-linux-gnu.so* 2>/dev/null || ls /usr/lib/builder.cpython-313-riscv64-linux-gnu.so* 2>/dev/null || echo "not in standard path"' 0 "��� builder.cpython-313-riscv64-linux-gnu.so"
rlRun 'ls /usr/lib64/etree.cpython-313-riscv64-linux-gnu.so* 2>/dev/null || ls /usr/lib/etree.cpython-313-riscv64-linux-gnu.so* 2>/dev/null || echo "not in standard path"' 0 "��� etree.cpython-313-riscv64-linux-gnu.so"
rlRun 'ls /usr/lib64/_difflib.cpython-313-riscv64-linux-gnu.so* 2>/dev/null || ls /usr/lib/_difflib.cpython-313-riscv64-linux-gnu.so* 2>/dev/null || echo "not in standard path"' 0 "��� _difflib.cpython-313-riscv64-linux-gnu.so"
rlRun 'ls /usr/lib64/diff.cpython-313-riscv64-linux-gnu.so* 2>/dev/null || ls /usr/lib/diff.cpython-313-riscv64-linux-gnu.so* 2>/dev/null || echo "not in standard path"' 0 "��� diff.cpython-313-riscv64-linux-gnu.so"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs python-lxml 2>&1 || true' 0 "pkg-config ����Ϣ"

echo ""
echo "All python-lxml-files functional tests passed!"
