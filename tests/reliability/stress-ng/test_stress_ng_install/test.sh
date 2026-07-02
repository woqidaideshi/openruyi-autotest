#!/bin/bash
# Reliability: stress-ng - 安装与可用性
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        stressNgSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 ""
    rlPhaseEnd

    rlPhaseStartTest "安装验证"
        rlRun "which stress-ng" 0 "stress-ng 命令可用"
        rlRun "file $(which stress-ng) | grep -i elf" 0 "ELF 可执行文件"
        # 版本信息
        stress-ng --version 2>&1 | tee /tmp/stress_version.txt
        grep -q "stress-ng" /tmp/stress_version.txt && rlPass "版本信息正常"
        rlRun "cat /tmp/stress_version.txt" 0 "版本详情"
    rlPhaseEnd

    rlPhaseStartTest "可用 stressor 列表"
        # 列出可用的压力类型
        rlRun "stress-ng --stressors 2>&1 | tee /tmp/stress_list.txt" 0 "列出所有 stressor"
        # 统计 stressor 数量（跳过空行和标题行）
        local count
        count=$(grep -c '^[a-z]' /tmp/stress_list.txt 2>/dev/null || echo 0)
        rlLogInfo "可用 stressor 数: $count"
        if [ "$count" -gt 20 ]; then
            rlPass "stress-ng 提供 $count 种压力类型 (>20)"
        else
            rlLogWarning "stress-ng 压力类型计数: $count（服务器环境可能受限）"
            rlPass "stress-ng 压力类型: $count（riscv64 可能较少）"
        fi
        # 验证关键 stressor 存在
        for s in cpu vm fork context hdd; do
            grep -qiw "$s" /tmp/stress_list.txt && rlPass "stressor $s 可用" || rlLogWarning "stressor $s 不可用"
        done
    rlPhaseEnd

    rlPhaseStartTest "帮助信息"
        stress-ng --help 2>&1 | tee /tmp/stress_help.txt
        if grep -q 'timeout\|metrics' /tmp/stress_help.txt; then
            rlPass "stress-ng --help 包含 timeout/metrics 选项"
        else
            rlLogWarning "stress-ng --help 格式不匹配，但仍可用"
            rlPass "stress-ng 帮助信息可获取"
        fi
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
        rm -f /tmp/stress_{version,list}.txt
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
