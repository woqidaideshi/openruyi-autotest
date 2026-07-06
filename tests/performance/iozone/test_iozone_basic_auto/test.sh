#!/bin/bash
# Performance: iozone - 基础自动模式 (-a): 自动测试多种块大小和文件大小
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        iozoneSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时目录"
        sync && echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null 2>&1 || true
        rlLogInfo "缓存已清理"
    rlPhaseEnd

    rlPhaseStartTest "Auto Mode (-a) 小文件"
        local log="$TmpDir/iozone_auto_small.log"
        # -a: auto mode, -c: include close, 64m file
        rlRun "iozone -a -c -s 64m -r 4k -f $TmpDir/iozone_test.dat 2>&1 | tee $log" 0 "iozone -a -s 64m -r 4k"

        echo ""
        echo "=== IOzone Auto Mode 结果 (64M, 4K) ==="
        cat "$log"
        echo "=== 输出结束 ==="

        # 验证数据完整性
        grep -q "Auto Mode" "$log" && rlPass "Auto Mode 输出确认"
        grep -qE '^\s+[0-9]+\s+[0-9]+' "$log" && rlPass "数据行存在"
        _iozoneParseOutput "$log"
    rlPhaseEnd

    rlPhaseStartTest "Auto Mode (-a) 中等文件"
        sync && echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null 2>&1 || true
        local log="$TmpDir/iozone_auto_medium.log"
        rlRun "iozone -a -c -s 256m -r 16k -f $TmpDir/iozone_test2.dat 2>&1 | tee $log" 0 "iozone -a -s 256m -r 16k"

        echo ""
        echo "=== IOzone Auto Mode 结果 (256M, 16K) ==="
        cat "$log"
        echo "=== 输出结束 ==="

        grep -qE '^\s+[0-9]+\s+[0-9]+' "$log" && rlPass "数据行存在"
        _iozoneParseOutput "$log"
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
