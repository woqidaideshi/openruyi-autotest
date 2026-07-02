#!/bin/bash
# Reliability: stress-ng - 进程压力 (--fork/--context/--zombie/--wait)
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        stressNgSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 ""
        TAINT=$(_stressNgTaintBefore)
    rlPhaseEnd

    rlPhaseStartTest "FORK stress"
        local log="$TmpDir/fork.log"
        rlRun "stress-ng --fork 4 --timeout 30s --metrics-brief --log-file $log 2>&1 | tail -5" 0 "--fork 4"
        _stressNgValidate "$log" "fork"
        # fork 应有大量 bogo ops
        grep "fork" "$log" | head -3
    rlPhaseEnd

    rlPhaseStartTest "CONTEXT switch stress"
        local log="$TmpDir/context.log"
        rlRun "stress-ng --context 4 --timeout 30s --metrics-brief --log-file $log 2>&1 | tail -5" 0 "--context 4"
        _stressNgValidate "$log" "context"
    rlPhaseEnd

    rlPhaseStartTest "ZOMBIE stress"
        # zombie 会产生僵尸进程然后回收，文档标注可能有预期报错
        local log="$TmpDir/zombie.log"
        rlRun "stress-ng --zombie 2 --timeout 15s --metrics-brief --log-file $log 2>&1 | tail -5" 0 "--zombie 2"
        _stressNgValidate "$log" "zombie"
    rlPhaseEnd

    rlPhaseStartTest "WAIT stress (get/gettid)"
        local log="$TmpDir/wait.log"
        # --get: 频繁调用 getpid/getppid 等
        rlRun "stress-ng --get 4 --timeout 20s --metrics-brief --log-file $log 2>&1 | tail -5" 0 "--get 4"
        _stressNgValidate "$log" "get"
    rlPhaseEnd

    rlPhaseStartTest "tainted"
        _stressNgTaintCheck "$TAINT"
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
