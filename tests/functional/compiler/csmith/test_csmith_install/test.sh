#!/bin/bash
# Functional test: compiler - csmith - 安装与可用性检查
# 验证 csmith 命令可用、版本信息正确、可生成随机 C 程序

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        csmithSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时目录"
    rlPhaseEnd

    rlPhaseStartTest "Csmith 安装验证"
        # 检查命令是否存在
        rlRun "which csmith" 0 "csmith 命令存在"
        
        # 检查版本信息
        csmith --version 2>&1 | tee /tmp/csmith_version.txt
        if grep -qi "csmith\|version" /tmp/csmith_version.txt; then
            rlPass "csmith --version 输出正常"
        else
            rlFail "csmith --version 输出异常"
        fi
        
        # 生成随机 C 程序
        rlRun "csmith > random1.c 2>/tmp/csmith_stderr.txt" 0 "生成随机 C 程序"
        
        # 验证生成的 C 文件非空且语法看起来正确
        if [ -s random1.c ]; then
            local lines
            lines=$(wc -l < random1.c)
            rlPass "Csmith 生成 C 程序 ($lines 行)"
            
            # 检查是否包含 main 函数
            if grep -q "int main" random1.c; then
                rlPass "生成的程序包含 main 函数"
            else
                rlFail "生成的程序缺少 main 函数"
            fi
            
            # 检查是否包含 C 标准头文件引用
            if grep -q "#include" random1.c; then
                rlPass "生成的程序包含头文件引用"
            fi
        else
            rlFail "Csmith 未生成有效的 C 程序"
        fi
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 "离开临时目录"
        [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "清理临时目录"
        rm -f /tmp/csmith_version.txt /tmp/csmith_stderr.txt
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
