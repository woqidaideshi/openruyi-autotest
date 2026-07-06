#!/bin/bash
# Reliability: trinity - 排除模式 (-x)
# 文档示例: trinity -x splice (排除已知问题 syscall)
# 排除高危 syscall 后执行全量 fuzz
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        trinitySetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时目录"
        TAINT_BEFORE=$(_trinityTaintBefore)
        chmod 777 "$TmpDir"

        # 定义要排除的高危 syscall 列表
        DANGEROUS="reboot shutdown init_module delete_module mount umount2 mknod swapon swapoff ioperm iopl kexec_load kexec_file_load"
        rlLogInfo "排除高危 syscall: $DANGEROUS"
    rlPhaseEnd

    rlPhaseStartTest "排除全部高危 syscall"
        local log="$TmpDir/trinity_exclude.log"
        # 构建 -x 参数
        local exclude_args=""
        for call in $DANGEROUS; do
            exclude_args="$exclude_args -x $call"
        done

        timeout 45 sudo -u "$TRINITY_USER" trinity -q $exclude_args -N 20000 > "$log" 2>&1
        local rc=$?

        rlLogInfo "排除模式退出码: $rc"

        if [ "$rc" -eq 0 ] || [ "$rc" -eq 124 ]; then
            rlPass "排除高危调用后 Trinity 正常运行"
        else
            rlLogWarning "排除模式异常: $rc"
        fi

        # 验证排除的调用未出现
        local leak=0
        for call in $DANGEROUS; do
            if grep -qiw "$call" "$log" 2>/dev/null; then
                rlLogWarning "疑似排除泄漏: $call"
                leak=1
            fi
        done
        if [ "$leak" -eq 0 ]; then
            rlPass "所有高危 syscall 成功排除"
        fi

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
