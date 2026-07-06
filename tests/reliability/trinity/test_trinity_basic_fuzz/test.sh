#!/bin/bash
# Reliability: trinity - 基础模糊测试 60s
# 文档推荐: trinity -q -N 99999
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        trinitySetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时目录"
        # 记录测试前内核 tainted 状态
        TAINT_BEFORE=$(_trinityTaintBefore)
        rlLogInfo "测试前 tainted: $TAINT_BEFORE"
        # 确保 TmpDir 可写
        chmod 777 "$TmpDir"
    rlPhaseEnd

    rlPhaseStartTest "基础系统调用模糊测试"
        local log_file="$TmpDir/trinity_basic.log"
        # 以非 root 用户运行 trinity, 时间限制 60s
        timeout 70 sudo -u "$TRINITY_USER" trinity -q -N 99999 > "$log_file" 2>&1
        local rc=$?
        rlLogInfo "Trinity 退出码: $rc"

        if [ "$rc" -eq 124 ]; then
            rlPass "Trinity 被 timeout 正常终止 (60s 后)"
        elif [ "$rc" -eq 0 ]; then
            rlPass "Trinity 正常退出 (所有 syscall 完成)"
        else
            rlLogWarning "Trinity 非零退出码: $rc"
        fi

        # 检查输出
        rlRun "wc -l < $log_file" 0 "输出行数统计"
        _trinityCheckOutput "$log_file"

        # 显示最后的输出
        rlRun "tail -20 $log_file" 0 "Trinity 最后 20 行输出"
    rlPhaseEnd

    rlPhaseStartTest "tainted 状态检查"
        _trinityTaintCheck "$TAINT_BEFORE"
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
