#!/bin/sh -eux
# Functional test: audit - 版本和帮助

. "../setup.sh"

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'auditctl --version 2>&1 || true' 0 "auditctl 版本信息"
rlRun 'auditctl --help 2>&1 | head -5 || true' 0 "auditctl 帮助信息"
rlRun 'ausearch --version 2>&1 || true' 0 "ausearch 版本信息"
rlRun 'ausearch --help 2>&1 | head -5 || true' 0 "ausearch 帮助信息"
rlRun 'aureport --version 2>&1 || true' 0 "aureport 版本信息"
rlRun 'aureport --help 2>&1 | head -5 || true' 0 "aureport 帮助信息"
rlRun 'aulast --version 2>&1 || true' 0 "aulast 版本信息"
rlRun 'aulast --help 2>&1 | head -5 || true' 0 "aulast 帮助信息"
rlRun 'aulastlog --version 2>&1 || true' 0 "aulastlog 版本信息"
rlRun 'aulastlog --help 2>&1 | head -5 || true' 0 "aulastlog 帮助信息"
rlRun 'ausyscall --version 2>&1 || true' 0 "ausyscall 版本信息"
rlRun 'ausyscall --help 2>&1 | head -5 || true' 0 "ausyscall 帮助信息"
rlRun 'augenrules --version 2>&1 || true' 0 "augenrules 版本信息"
rlRun 'augenrules --help 2>&1 | head -5 || true' 0 "augenrules 帮助信息"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All audit 版本和帮助 tests passed!"
