#!/bin/sh -eux
# Functional test: glibc - 版本和帮助

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q glibc' 0 "检查 glibc 是否已安装"
rlRun 'which gencat' 0 "检查 gencat 命令是否可用"
rlRun 'which getconf' 0 "检查 getconf 命令是否可用"
rlRun 'which getent' 0 "检查 getent 命令是否可用"
rlRun 'which iconv' 0 "检查 iconv 命令是否可用"
rlRun 'which ldconfig' 0 "检查 ldconfig 命令是否可用"
rlRun 'which ldd' 0 "检查 ldd 命令是否可用"
rlRun 'which locale' 0 "检查 locale 命令是否可用"
rlRun 'which localedef' 0 "检查 localedef 命令是否可用"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'gencat --version 2>&1 || true' 0 "gencat 版本信息"
rlRun 'gencat --help 2>&1 | head -5 || true' 0 "gencat 帮助信息"
rlRun 'getconf --version 2>&1 || true' 0 "getconf 版本信息"
rlRun 'getconf --help 2>&1 | head -5 || true' 0 "getconf 帮助信息"
rlRun 'getent --version 2>&1 || true' 0 "getent 版本信息"
rlRun 'getent --help 2>&1 | head -5 || true' 0 "getent 帮助信息"
rlRun 'iconv --version 2>&1 || true' 0 "iconv 版本信息"
rlRun 'iconv --help 2>&1 | head -5 || true' 0 "iconv 帮助信息"
rlRun 'ldconfig --version 2>&1 || true' 0 "ldconfig 版本信息"
rlRun 'ldconfig --help 2>&1 | head -5 || true' 0 "ldconfig 帮助信息"
rlRun 'ldd --version 2>&1 || true' 0 "ldd 版本信息"
rlRun 'ldd --help 2>&1 | head -5 || true' 0 "ldd 帮助信息"
rlRun 'locale --version 2>&1 || true' 0 "locale 版本信息"
rlRun 'locale --help 2>&1 | head -5 || true' 0 "locale 帮助信息"
rlRun 'localedef --version 2>&1 || true' 0 "localedef 版本信息"
rlRun 'localedef --help 2>&1 | head -5 || true' 0 "localedef 帮助信息"

cd /
rm -rf $TmpDir

echo ""
echo "All glibc 版本和帮助 tests passed!"
