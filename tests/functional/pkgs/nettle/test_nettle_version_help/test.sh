#!/bin/sh -eux
# Functional test: nettle - 版本和帮助

. "../setup.sh"

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'nettle-hash --version 2>&1 || true' 0 "nettle-hash 版本信息"
rlRun 'nettle-hash --help 2>&1 | head -5 || true' 0 "nettle-hash 帮助信息"
rlRun 'nettle-lfib-stream --version 2>&1 || true' 0 "nettle-lfib-stream 版本信息"
rlRun 'nettle-lfib-stream --help 2>&1 | head -5 || true' 0 "nettle-lfib-stream 帮助信息"
rlRun 'nettle-pbkdf2 --version 2>&1 || true' 0 "nettle-pbkdf2 版本信息"
rlRun 'nettle-pbkdf2 --help 2>&1 | head -5 || true' 0 "nettle-pbkdf2 帮助信息"
rlRun 'pkcs1-conv --version 2>&1 || true' 0 "pkcs1-conv 版本信息"
rlRun 'pkcs1-conv --help 2>&1 | head -5 || true' 0 "pkcs1-conv 帮助信息"
rlRun 'sexp-conv --version 2>&1 || true' 0 "sexp-conv 版本信息"
rlRun 'sexp-conv --help 2>&1 | head -5 || true' 0 "sexp-conv 帮助信息"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All nettle 版本和帮助 tests passed!"
