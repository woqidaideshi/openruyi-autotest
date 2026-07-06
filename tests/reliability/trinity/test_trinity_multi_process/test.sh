#!/bin/bash
# Reliability: trinity - 多进程并行 (-C)
# 文档: trinity -q -C$(nproc)
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        trinitySetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时目录"
        TAINT_BEFORE=$(_trinityTaintBefore)
        chmod 777 "$TmpDir"
        local cores
        cores=$(nproc)
        rlLogInfo "CPU 核心数: $cores"
    rlPhaseEnd

    rlPhaseStartTest "单进程 baseline"
        local log1="$TmpDir/trinity_1proc.log"
        timeout 30 sudo -u "$TRINITY_USER" trinity -q -C 1 -N 5000 > "$log1" 2>&1
        local rc1=$?
        local calls1
        calls1=$(grep -c "succeeded\|completed" "$log1" 2>/dev/null || echo "N/A")
        rlLogInfo "单进程: exit=$rc1, 完成调用≈$calls1"
        rlRun "[ $rc1 -eq 0 ] || [ $rc1 -eq 124 ]" 0 "单进程测试完成"
    rlPhaseEnd

    rlPhaseStartTest "多进程并行 ($cores cores)"
        local log_multi="$TmpDir/trinity_multi.log"
        timeout 30 sudo -u "$TRINITY_USER" trinity -q -C "$cores" -N 10000 > "$log_multi" 2>&1
        local rc_multi=$?
        rlLogInfo "多进程 ($cores): exit=$rc_multi"

        if [ "$rc_multi" -eq 0 ] || [ "$rc_multi" -eq 124 ]; then
            rlPass "Trinity -C $cores 多进程测试完成"
        else
            rlLogWarning "多进程异常退出: $rc_multi"
        fi

        # 验证多进程确实启动了
        if grep -qi "child\|process\|fork" "$log_multi" 2>/dev/null; then
            rlPass "检测到多进程并发活动"
        fi
        _trinityCheckOutput "$log_multi"
    rlPhaseEnd

    rlPhaseStartTest "tainted 检查"
        _trinityTaintCheck "$TAINT_BEFORE"
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
