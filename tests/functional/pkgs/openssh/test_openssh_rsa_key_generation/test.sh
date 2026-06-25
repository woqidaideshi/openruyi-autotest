#!/bin/bash
# Functional test: openssh - RSA-key-generation
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

    rlPhaseStartTest "RSA-key-generation"
        rlRun "ssh-keygen -t rsa -b 2048 -f test_rsa -N \"\" -q" 0 "Generate RSA 2048 key"
        rlRun "test -f test_rsa" 0 "Private key exists"
        rlRun "test -f test_rsa.pub" 0 "Public key exists"
        rlRun "ssh-keygen -l -f test_rsa" 0 "Show RSA key fingerprint"
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
