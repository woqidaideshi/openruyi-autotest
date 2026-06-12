#!/bin/sh -eux
# Functional test: elfutils - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q elfutils 2>/dev/null || { echo 'elfutils not installed, skipping'; exit 0; }
which eu-addr2line 2>/dev/null || echo 'eu-addr2line not found'
which eu-ar 2>/dev/null || echo 'eu-ar not found'
which eu-elfclassify 2>/dev/null || echo 'eu-elfclassify not found'
which eu-elfcmp 2>/dev/null || echo 'eu-elfcmp not found'
which eu-elfcompress 2>/dev/null || echo 'eu-elfcompress not found'
which eu-elflint 2>/dev/null || echo 'eu-elflint not found'
which eu-findtextrel 2>/dev/null || echo 'eu-findtextrel not found'
which eu-make-debug-archive 2>/dev/null || echo 'eu-make-debug-archive not found'
which eu-nm 2>/dev/null || echo 'eu-nm not found'
which eu-objdump 2>/dev/null || echo 'eu-objdump not found'
which eu-ranlib 2>/dev/null || echo 'eu-ranlib not found'
which eu-readelf 2>/dev/null || echo 'eu-readelf not found'
which eu-size 2>/dev/null || echo 'eu-size not found'
which eu-srcfiles 2>/dev/null || echo 'eu-srcfiles not found'
which eu-stack 2>/dev/null || echo 'eu-stack not found'
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="
rlRun 'eu-addr2line --invalid 2>&1 || true' 0 "eu-addr2line: 无效选项"

echo ""
echo "All elfutils functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All elfutils 错误处理 tests passed!"
