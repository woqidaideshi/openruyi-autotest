#!/bin/bash
# Functional test: coreutils - Permissions-and-ownership--chmod--chown--chgrp
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        coreutilsSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "Permissions-and-ownership--chmod--chown--chgrp"
        rlRun "touch perm_test.txt" 0 "Create permission test file"
        rlRun "chmod u+x perm_test.txt" 0 "chmod u+x add exec"
        rlRun "test -x perm_test.txt" 0 "chmod: verify exec set"
        rlRun "chmod 644 perm_test.txt" 0 "chmod 644 numeric"
        rlRun "ls -l perm_test.txt | grep -q \"rw-r--r--\"" 0 "chmod: verify 644 perms"
        rlRun "mkdir -p perm_dir && touch perm_dir/f1 perm_dir/f2" 0 "Setup recursive chmod"
        rlRun "chmod -R 755 perm_dir" 0 "chmod -R recursive"
        rlRun "chown --version" 0 "chown version check"
        rlRun "chown $whoami_val perm_test.txt 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "chown to self"
        rlRun "chgrp --version" 0 "chgrp version check"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # coreutils 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
