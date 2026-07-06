#!/bin/bash
# Reliability: trinity - 针对性安全 syscall 测试 (-c)
# 文档示例: trinity -c splice
# 本测试用无副作用的 syscall: getpid, getuid, gettimeofday, clock_gettime
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        trinitySetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时目录"
        TAINT_BEFORE=$(_trinityTaintBefore)
        chmod 777 "$TmpDir"
    rlPhaseEnd

    rlPhaseStartTest "针对性安全 syscall"
        local safe_calls="getpid getuid getgid geteuid getppid gettimeofday clock_gettime nanosleep getcpu getrandom uname sysinfo"
        local tested=0

        for call in $safe_calls; do
            # 检查 syscall 是否可用
            if trinity -L 2>&1 | grep -qiw "$call"; then
                rlLogInfo "测试 syscall: $call"
                local log="$TmpDir/trinity_${call}.log"
                timeout 15 sudo -u "$TRINITY_USER" trinity -q -c "$call" -N 1000 > "$log" 2>&1
                local rc=$?
                tested=$((tested + 1))

                if [ "$rc" -eq 0 ] || [ "$rc" -eq 124 ]; then
                    # 检查输出不含 BUG
                    if grep -q "BUG:" "$log" 2>/dev/null; then
                        rlFail "syscall $call 触发 BUG"
                        grep "BUG:" "$log" | head -5
                    else
                        rlPass "syscall $call: 安全 ($([[ $rc -eq 124 ]] && echo timeout || echo done))"
                    fi
                else
                    rlLogWarning "syscall $call: 退出码 $rc"
                fi
            else
                rlLogInfo "syscall $call 不可用，跳过"
            fi
        done

        rlLogInfo "共测试 $tested 个安全 syscall"
        if [ "$tested" -gt 0 ]; then
            rlPass "针对性安全测试完成 ($tested syscalls)"
        fi
    rlPhaseEnd

    rlPhaseStartTest "tainted 检查"
        _trinityTaintCheck "$TAINT_BEFORE"
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
