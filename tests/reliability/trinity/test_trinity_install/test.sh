#!/bin/bash
# Reliability: trinity - 安装与可用性验证
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        trinitySetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时目录"
    rlPhaseEnd

    rlPhaseStartTest "Trinity 安装验证"
        rlRun "which trinity" 0 "trinity 命令可用"
        rlRun "file $(which trinity)" 0 "trinity 文件类型"
        file $(which trinity) | tee /tmp/trinity_file.txt
        grep -qi "ELF" /tmp/trinity_file.txt && rlPass "trinity 为 ELF 可执行文件"
        # 版本信息
        trinity --version 2>&1 | tee /tmp/trinity_version.txt
        if [ -s /tmp/trinity_version.txt ]; then
            rlPass "trinity --version 有输出"
        fi
        # 列出可用 syscall
        rlRun "trinity -L 2>&1 | head -40" 0 "列出前 40 个可用 syscall"
        local syscall_count
        syscall_count=$(trinity -L 2>&1 | wc -l)
        rlLogInfo "可用 syscall 总数: $syscall_count"
        if [ "$syscall_count" -gt 10 ]; then
            rlPass "Trinity 识别 $syscall_count 个 syscall (>10)"
        else
            rlFail "Trinity syscall 数量过少"
        fi
    rlPhaseEnd

    rlPhaseStartTest "非 root 用户验证"
        rlRun "id $TRINITY_USER" 0 "Trinity 用户存在"
        # 验证 trinity 以非 root 用户可运行（dry-run 检查）
        echo openruyi | sudo -S -u "$TRINITY_USER" trinity --version 2>&1 | tee /tmp/trinity_user.txt
        if grep -qi "trinity\|version" /tmp/trinity_user.txt; then
            rlPass "非 root 用户可执行 trinity"
        fi
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
        rm -f /tmp/trinity_{file,version,user}.txt
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
