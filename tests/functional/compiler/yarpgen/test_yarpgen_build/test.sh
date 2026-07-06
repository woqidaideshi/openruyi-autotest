#!/bin/bash
# Functional test: compiler - yarpgen - 源码构建与安装
# 克隆 yarpgen 仓库，cmake 构建，验证可执行文件生成

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        yarpgenSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时目录"
    rlPhaseEnd

    rlPhaseStartTest "YARPGen 构建验证"
        # 检查仓库目录
        if [ -d "/tmp/yarpgen" ]; then
            rlPass "yarpgen 源码目录存在"
            
            # 检查关键源文件
            if [ -f "/tmp/yarpgen/CMakeLists.txt" ]; then
                rlPass "CMakeLists.txt 存在"
            fi
            
            if [ -d "/tmp/yarpgen/src" ]; then
                rlPass "src 目录存在"
                rlRun "ls /tmp/yarpgen/src/" 0 "列出源文件"
            fi
        else
            rlFail "yarpgen 源码目录不存在"
        fi
        
        # 检查构建目录
        if [ -d "/tmp/yarpgen/build" ]; then
            rlPass "build 目录存在"
        else
            rlFail "build 目录不存在"
        fi
        
        # 检查 yarpgen 可执行文件
        if [ -f "/tmp/yarpgen/build/yarpgen" ]; then
            rlPass "yarpgen 可执行文件已生成"
            
            # 检查文件类型
            rlRun "file /tmp/yarpgen/build/yarpgen" 0 "检查 yarpgen 文件类型"
            file /tmp/yarpgen/build/yarpgen | tee /tmp/yarpgen_file.txt
            if grep -qi "ELF" /tmp/yarpgen_file.txt; then
                rlPass "yarpgen 为 ELF 可执行文件"
            fi
            
            # 检查版本/帮助信息
            /tmp/yarpgen/build/yarpgen --help 2>&1 | tee /tmp/yarpgen_help.txt
            if [ -s /tmp/yarpgen_help.txt ]; then
                rlPass "yarpgen --help 有输出"
            fi
            
            # 测试生成随机程序
            rlRun "/tmp/yarpgen/build/yarpgen 2>&1" 0 "执行 yarpgen 生成随机程序"
            
            # 检查生成的输出文件
            local gen_files=0
            for f in init.h func.cpp driver.cpp; do
                if [ -f "$f" ]; then
                    gen_files=$((gen_files + 1))
                    rlPass "生成 $f ($(wc -l < $f) 行)"
                fi
            done
            
            if [ "$gen_files" -eq 3 ]; then
                rlPass "YARPGen 成功生成全部 3 个文件 (init.h + func.cpp + driver.cpp)"
            else
                rlFail "YARPGen 只生成了 $gen_files/3 个文件"
            fi
        else
            rlFail "yarpgen 可执行文件未生成"
        fi
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 "离开临时目录"
        [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "清理临时目录"
        rm -f /tmp/yarpgen_{file,help}.txt
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
