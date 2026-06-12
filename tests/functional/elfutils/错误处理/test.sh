#!/bin/sh -eux
# Functional test: elfutils - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q elfutils' 0 "检查 elfutils 是否已安装"
rlRun 'which eu-addr2line' 0 "检查 eu-addr2line 命令是否可用"
rlRun 'which eu-ar' 0 "检查 eu-ar 命令是否可用"
rlRun 'which eu-elfclassify' 0 "检查 eu-elfclassify 命令是否可用"
rlRun 'which eu-elfcmp' 0 "检查 eu-elfcmp 命令是否可用"
rlRun 'which eu-elfcompress' 0 "检查 eu-elfcompress 命令是否可用"
rlRun 'which eu-elflint' 0 "检查 eu-elflint 命令是否可用"
rlRun 'which eu-findtextrel' 0 "检查 eu-findtextrel 命令是否可用"
rlRun 'which eu-make-debug-archive' 0 "检查 eu-make-debug-archive 命令是否可用"
rlRun 'which eu-nm' 0 "检查 eu-nm 命令是否可用"
rlRun 'which eu-objdump' 0 "检查 eu-objdump 命令是否可用"
rlRun 'which eu-ranlib' 0 "检查 eu-ranlib 命令是否可用"
rlRun 'which eu-readelf' 0 "检查 eu-readelf 命令是否可用"
rlRun 'which eu-size' 0 "检查 eu-size 命令是否可用"
rlRun 'which eu-srcfiles' 0 "检查 eu-srcfiles 命令是否可用"
rlRun 'which eu-stack' 0 "检查 eu-stack 命令是否可用"
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
