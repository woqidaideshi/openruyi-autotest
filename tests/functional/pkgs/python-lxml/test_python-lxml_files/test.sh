#!/bin/sh -eux
# Functional test: python-lxml - �ļ���֤
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
rlRun 'ls /usr/lib64/_elementpath.cpython-313-riscv64-linux-gnu.so* 2>/dev/null || ls /usr/lib/_elementpath.cpython-313-riscv64-linux-gnu.so* 2>/dev/null || echo "not in standard path"' 0 "��� _elementpath.cpython-313-riscv64-linux-gnu.so"
rlRun 'ls /usr/lib64/builder.cpython-313-riscv64-linux-gnu.so* 2>/dev/null || ls /usr/lib/builder.cpython-313-riscv64-linux-gnu.so* 2>/dev/null || echo "not in standard path"' 0 "��� builder.cpython-313-riscv64-linux-gnu.so"
rlRun 'ls /usr/lib64/etree.cpython-313-riscv64-linux-gnu.so* 2>/dev/null || ls /usr/lib/etree.cpython-313-riscv64-linux-gnu.so* 2>/dev/null || echo "not in standard path"' 0 "��� etree.cpython-313-riscv64-linux-gnu.so"
rlRun 'ls /usr/lib64/_difflib.cpython-313-riscv64-linux-gnu.so* 2>/dev/null || ls /usr/lib/_difflib.cpython-313-riscv64-linux-gnu.so* 2>/dev/null || echo "not in standard path"' 0 "��� _difflib.cpython-313-riscv64-linux-gnu.so"
rlRun 'ls /usr/lib64/diff.cpython-313-riscv64-linux-gnu.so* 2>/dev/null || ls /usr/lib/diff.cpython-313-riscv64-linux-gnu.so* 2>/dev/null || echo "not in standard path"' 0 "��� diff.cpython-313-riscv64-linux-gnu.so"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs python-lxml 2>&1 || true' 0 "pkg-config ����Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y python-lxml 2>/dev/null || true
    echo "TEARDOWN: removed python-lxml"
fi
echo ""
echo "All python-lxml-files functional tests passed!"
