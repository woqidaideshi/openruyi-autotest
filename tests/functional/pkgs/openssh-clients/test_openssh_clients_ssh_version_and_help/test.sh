#!/bin/bash
# Functional test: openssh-clients - clients - ssh-version-and-help
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        opensshClientsSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "clients - ssh-version-and-help"
        rlRun "ssh -V 2>&1" 0 "ssh version"
        rlRun "ssh -Q key 2>&1 | head -10" 0 "ssh -Q key: supported keys"
        rlRun "ssh -Q cipher 2>&1 | head -5" 0 "ssh -Q cipher: ciphers"
        rlRun "ssh -Q mac 2>&1 | head -5" 0 "ssh -Q mac: MACs"
        rlRun "ssh -Q kex 2>&1 | head -5" 0 "ssh -Q kex: key exchange"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # openssh-clients 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
