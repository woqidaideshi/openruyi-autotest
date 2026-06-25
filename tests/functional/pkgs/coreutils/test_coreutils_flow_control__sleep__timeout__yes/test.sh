#!/bin/bash
# Functional test: coreutils - Flow-control--sleep--timeout--yes
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

    rlPhaseStartTest "Flow-control--sleep--timeout--yes"
        rlRun "sleep 0.1" 0 "sleep delay"
        rlRun "timeout 2 sleep 0.1" 0 "timeout: command finishes in time"
        rlRun "timeout 2 sleep 0.1 && echo ok" 0 "timeout: successful completion"
        rlRun "timeout 0.1 sleep 5" 124 "timeout: kills slow command"
        rlRun "yes | head -5" 0 "yes repeated output"
        rlRun "yes hello | head -3" 0 "yes custom string"
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
