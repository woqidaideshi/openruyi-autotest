#!/bin/bash
# Functional test: ltp - ltp-aiodio-part1
# Beakerlib-based test with lifecycle management
# Executes the LTP ltp-aiodio-part1 test suite via runltp

. /usr/share/beakerlib/beakerlib.sh || exit 1

rlJournalStart
    rlPhaseStartSetup "环境准备"
        # Check if ltp package is installed
        if ! rpm -q ltp 2>/dev/null; then
            rlRun "echo openruyi | sudo -S dnf install -y ltp" 0 "安装 LTP 测试套件"
        fi
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "LTP ltp-aiodio-part1 测试"
        # Run LTP ltp-aiodio-part1 test suite
        rlRun "runltp -f ltp-aiodio-part1 -q" 0 "执行 LTP ltp-aiodio-part1 测试套"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
