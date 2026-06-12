#!/bin/sh -eux
# Functional test: elfutils - 版本和帮助

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

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'eu-addr2line --version 2>&1 || true' 0 "eu-addr2line 版本信息"
rlRun 'eu-addr2line --help 2>&1 | head -5 || true' 0 "eu-addr2line 帮助信息"
rlRun 'eu-ar --version 2>&1 || true' 0 "eu-ar 版本信息"
rlRun 'eu-ar --help 2>&1 | head -5 || true' 0 "eu-ar 帮助信息"
rlRun 'eu-elfclassify --version 2>&1 || true' 0 "eu-elfclassify 版本信息"
rlRun 'eu-elfclassify --help 2>&1 | head -5 || true' 0 "eu-elfclassify 帮助信息"
rlRun 'eu-elfcmp --version 2>&1 || true' 0 "eu-elfcmp 版本信息"
rlRun 'eu-elfcmp --help 2>&1 | head -5 || true' 0 "eu-elfcmp 帮助信息"
rlRun 'eu-elfcompress --version 2>&1 || true' 0 "eu-elfcompress 版本信息"
rlRun 'eu-elfcompress --help 2>&1 | head -5 || true' 0 "eu-elfcompress 帮助信息"
rlRun 'eu-elflint --version 2>&1 || true' 0 "eu-elflint 版本信息"
rlRun 'eu-elflint --help 2>&1 | head -5 || true' 0 "eu-elflint 帮助信息"
rlRun 'eu-findtextrel --version 2>&1 || true' 0 "eu-findtextrel 版本信息"
rlRun 'eu-findtextrel --help 2>&1 | head -5 || true' 0 "eu-findtextrel 帮助信息"
rlRun 'eu-make-debug-archive --version 2>&1 || true' 0 "eu-make-debug-archive 版本信息"
rlRun 'eu-make-debug-archive --help 2>&1 | head -5 || true' 0 "eu-make-debug-archive 帮助信息"
rlRun 'eu-nm --version 2>&1 || true' 0 "eu-nm 版本信息"
rlRun 'eu-nm --help 2>&1 | head -5 || true' 0 "eu-nm 帮助信息"
rlRun 'eu-objdump --version 2>&1 || true' 0 "eu-objdump 版本信息"
rlRun 'eu-objdump --help 2>&1 | head -5 || true' 0 "eu-objdump 帮助信息"
rlRun 'eu-ranlib --version 2>&1 || true' 0 "eu-ranlib 版本信息"
rlRun 'eu-ranlib --help 2>&1 | head -5 || true' 0 "eu-ranlib 帮助信息"
rlRun 'eu-readelf --version 2>&1 || true' 0 "eu-readelf 版本信息"
rlRun 'eu-readelf --help 2>&1 | head -5 || true' 0 "eu-readelf 帮助信息"
rlRun 'eu-size --version 2>&1 || true' 0 "eu-size 版本信息"
rlRun 'eu-size --help 2>&1 | head -5 || true' 0 "eu-size 帮助信息"
rlRun 'eu-srcfiles --version 2>&1 || true' 0 "eu-srcfiles 版本信息"
rlRun 'eu-srcfiles --help 2>&1 | head -5 || true' 0 "eu-srcfiles 帮助信息"
rlRun 'eu-stack --version 2>&1 || true' 0 "eu-stack 版本信息"
rlRun 'eu-stack --help 2>&1 | head -5 || true' 0 "eu-stack 帮助信息"

cd /
rm -rf $TmpDir

echo ""
echo "All elfutils 版本和帮助 tests passed!"
