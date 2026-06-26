#!/bin/bash
# Functional test: ltp - mm - ksm02_1
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1

rlJournalStart
    rlPhaseStartSetup "环境准备"
        if ! rpm -q ltp 2>/dev/null; then
            rlRun "echo openruyi | sudo -S dnf install -y ltp" 0 "安装 LTP"
        fi
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "LTP mm - ksm02_1"
        rlRun "runltp -f mm -s ksm02_1 -q" 0 "执行 LTP ksm02_1"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "清理"
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
