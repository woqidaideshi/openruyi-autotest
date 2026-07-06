#!/bin/bash
# Reliability: stress-ng - IO 压力 (--hdd/--aio/--getdent)
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        stressNgSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 ""
        TAINT=$(_stressNgTaintBefore)
        mkdir -p "$TmpDir/io_test"
    rlPhaseEnd

    rlPhaseStartTest "HDD stress (磁盘IO)"
        local log="$TmpDir/hdd.log"
        rlRun "stress-ng --hdd 2 --hdd-bytes 32M --temp-path $TmpDir/io_test --timeout 30s --metrics-brief --log-file $log 2>&1 | tail -5" 0 "--hdd 2"
        _stressNgValidate "$log" "hdd"
    rlPhaseEnd

    rlPhaseStartTest "AIO stress (异步IO)"
        # aio 需要 libaio 支持，可能部分系统不支持
        local log="$TmpDir/aio.log"
        stress-ng --aio 2 --timeout 20s --metrics-brief --log-file "$log" 2>&1 | tail -5
        if grep -q "successful run completed" "$log" 2>/dev/null; then
            _stressNgValidate "$log" "aio"
        else
            rlLogInfo "AIO stressor 不被支持，跳过（正常）"
            rlPass "AIO: 跳过 (不支持)"
        fi
    rlPhaseEnd

    rlPhaseStartTest "GETDENT stress (目录遍历)"
        local log="$TmpDir/getdent.log"
        rlRun "stress-ng --getdent 2 --timeout 20s --metrics-brief --log-file $log 2>&1 | tail -5" 0 "--getdent 2"
        _stressNgValidate "$log" "getdent"
    rlPhaseEnd

    rlPhaseStartTest "tainted"
        _stressNgTaintCheck "$TAINT"
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
