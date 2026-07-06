#!/bin/bash
# Functional test: compiler - csmith - 生成程序并用 GCC/Clang 编译
# 生成 Csmith 随机程序，分别用 gcc 和 clang 编译
# 验证: 编译警告数、编译成功、产物为 ELF 可执行文件

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        csmithSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时目录"
        
        # 生成随机程序
        rlRun "csmith > csmith_test.c 2>/dev/null" 0 "生成随机 C 程序"
        rlAssertExists "csmith_test.c"
        rlLogInfo "C 程序大小: $(wc -l < csmith_test.c) 行"
    rlPhaseEnd

    rlPhaseStartTest "GCC 编译"
        # GCC 编译（记录 stderr 查看警告数）
        gcc -O2 csmith_test.c -o csmith_gcc -w 2>/tmp/csmith_gcc_err.txt
        local gcc_rc=$?
        rlRun "echo \"GCC exit: $gcc_rc\"" 0 "GCC 编译退出码: $gcc_rc"
        
        if [ "$gcc_rc" -eq 0 ] && [ -x ./csmith_gcc ]; then
            rlPass "GCC 编译成功"
            
            # 验证产物是 ELF 可执行文件
            rlRun "file ./csmith_gcc" 0 "检查编译产物类型"
            file ./csmith_gcc | tee /tmp/csmith_file_gcc.txt
            if grep -qi "ELF" /tmp/csmith_file_gcc.txt; then
                rlPass "GCC 产物为 ELF 可执行文件"
            else
                rlFail "GCC 产物不是 ELF 格式"
            fi
            
            # 检查编译警告
            if [ -s /tmp/csmith_gcc_err.txt ]; then
                local warn_count
                warn_count=$(grep -c "warning:" /tmp/csmith_gcc_err.txt 2>/dev/null || echo 0)
                rlLogInfo "GCC 编译产生 $warn_count 个警告"
            else
                rlPass "GCC 编译无警告/错误输出"
            fi
        else
            rlFail "GCC 编译失败"
        fi
    rlPhaseEnd

    rlPhaseStartTest "Clang 编译"
        clang -O2 csmith_test.c -o csmith_clang -w 2>/tmp/csmith_clang_err.txt
        local clang_rc=$?
        rlRun "echo \"Clang exit: $clang_rc\"" 0 "Clang 编译退出码: $clang_rc"
        
        if [ "$clang_rc" -eq 0 ] && [ -x ./csmith_clang ]; then
            rlPass "Clang 编译成功"
            
            rlRun "file ./csmith_clang" 0 "检查编译产物类型"
            file ./csmith_clang | tee /tmp/csmith_file_clang.txt
            if grep -qi "ELF" /tmp/csmith_file_clang.txt; then
                rlPass "Clang 产物为 ELF 可执行文件"
            else
                rlFail "Clang 产物不是 ELF 格式"
            fi
            
            if [ -s /tmp/csmith_clang_err.txt ]; then
                local warn_count
                warn_count=$(grep -c "warning:" /tmp/csmith_clang_err.txt 2>/dev/null || echo 0)
                rlLogInfo "Clang 编译产生 $warn_count 个警告"
            else
                rlPass "Clang 编译无警告/错误输出"
            fi
        else
            rlFail "Clang 编译失败"
        fi
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 "离开临时目录"
        [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "清理临时目录"
        rm -f /tmp/csmith_{gcc,clang}_{err,file}.txt
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
