#!/bin/bash
# Reliability: trinity - 全速压力测试
# 文档推荐: trinity -qq -l off -C$(nproc)
# 关闭日志和冗余输出，以最快速度运行
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
    rlPhaseEnd

    rlPhaseStartTest "全速模式 -qq -l off"
        local log="$TmpDir/trinity_stress.log"
        # 文档推荐方法: trinity -qq -l off -C$(nproc)
        timeout 45 sudo -u "$TRINITY_USER" trinity -qq -l off -C "$cores" > "$log" 2>&1
        local rc=$?

        rlLogInfo "全速测试退出码: $rc"

        if [ "$rc" -eq 124 ]; then
            rlPass "全速压力测试 timeout 完成 (45s, $cores 进程)"
        elif [ "$rc" -eq 0 ]; then
            rlPass "全速压力测试正常完成"
        else
            # 检查是否是信号终止 (137 = SIGKILL, 143 = SIGTERM)
            if [ "$rc" -eq 137 ] || [ "$rc" -eq 143 ]; then
                rlLogWarning "全速模式被信号终止: $rc"
            else
                rlLogWarning "全速模式异常退出: $rc"
            fi
        fi

        # 输出统计
        rlRun "wc -l < $log 2>/dev/null || echo 0" 0 "输出行数"
        rlRun "tail -10 $log 2>/dev/null || echo empty" 0 "最后输出"

        # 检查异常
        _trinityCheckOutput "$log"
    rlPhaseEnd

    rlPhaseStartTest "tainted 检查"
        _trinityTaintCheck "$TAINT_BEFORE"
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
