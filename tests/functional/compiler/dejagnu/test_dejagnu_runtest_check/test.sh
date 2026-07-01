#!/bin/bash
# Functional test: compiler - dejagnu - runtest 基础可用性检查
# 验证 runtest 命令可用、版本信息正常、基本帮助输出

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        dejagnuSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时目录"
    rlPhaseEnd

    rlPhaseStartTest "runtest 命令可用性"
        # 检查 runtest 是否存在
        rlRun "which runtest" 0 "runtest 命令存在"
        
        # 检查版本输出
        runtest --version 2>&1 | tee /tmp/dejagnu_version.txt
        if grep -qi "dejagnu" /tmp/dejagnu_version.txt; then
            rlPass "runtest --version 包含 DejaGnu 信息"
        else
            rlFail "runtest --version 输出异常"
        fi
        
        # 检查帮助输出
        runtest --help 2>&1 | tee /tmp/dejagnu_help.txt
        if grep -q "\-\-tool" /tmp/dejagnu_help.txt; then
            rlPass "runtest --help 包含 --tool 选项说明"
        else
            rlFail "runtest --help 缺少 --tool 选项"
        fi
        
        # 验证可以无参数运行（会报错但不应 segfault）
        runtest 2>&1 | tee /tmp/dejagnu_noargs.txt
        local rc=$?
        if [ "$rc" -ne 0 ]; then
            rlPass "runtest 无参数运行正确退出 (非零 exit code 是可预期的)"
        else
            rlFail "runtest 无参数运行时意外返回 0"
        fi
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 "离开临时目录"
        [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "清理临时目录"
        rm -f /tmp/dejagnu_version.txt /tmp/dejagnu_help.txt /tmp/dejagnu_noargs.txt
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
