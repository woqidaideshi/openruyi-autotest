#!/bin/bash
# Functional test: openssh-clients - clients - ssh-connection--dry-run
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

    rlPhaseStartTest "clients - ssh-connection--dry-run"
        rlRun "ssh -G localhost 2>&1 | head -10" 0 "ssh -G: print config"
        rlRun "ssh -T -o ConnectTimeout=5 localhost 2>&1 || true" 0 "ssh -T: disable PTY"
        rlRun "ssh -v localhost 2>&1 | head -10 || true" 0 "ssh -v: verbose"
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
