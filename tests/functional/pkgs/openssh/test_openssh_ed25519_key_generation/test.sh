#!/bin/bash
# Functional test: openssh - Ed25519-key-generation
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        opensshSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "Ed25519-key-generation"
        rlRun "ssh-keygen -t ed25519 -f test_ed25519 -N \"\" -q" 0 "Generate Ed25519 key"
        rlRun "ssh-keygen -l -f test_ed25519.pub" 0 "Show Ed25519 fingerprint"
        rlRun "ssh-keygen -l -v -f test_ed25519.pub 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "Verbose fingerprint"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # openssh 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
