#!/bin/bash
# Functional test: compiler - yarpgen - 生成程序并用 G++/Clang 编译
# 用 yarpgen 生成随机 C++ 程序，分别用 g++ 和 clang 编译
# 验证: 编译成功、产物为 ELF、检查编译警告/错误

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

YARPGEN_BIN="/tmp/yarpgen/build/yarpgen"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        yarpgenSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时目录"
        
        if [ ! -x "$YARPGEN_BIN" ]; then
            rlFail "yarpgen 可执行文件不可用"
        else
            # 生成随机 C++ 程序
            rlRun "$YARPGEN_BIN 2>&1" 0 "生成随机 C++ 程序"
            for f in init.h func.cpp driver.cpp; do
                rlAssertExists "$f"
            done
            
            # 显示生成的代码行数
            rlRun "wc -l init.h func.cpp driver.cpp" 0 "生成的代码行数统计"
        fi
    rlPhaseEnd

    rlPhaseStartTest "G++ 编译"
        if [ ! -f "func.cpp" ]; then
            rlFail "源代码文件不存在，跳过"
        else
            # G++ -O0
            rlRun "g++ -fPIC func.cpp driver.cpp -o yarpgen_gxx_O0 -O0 2>/tmp/yarpgen_gxx_O0_err.txt" 0 "G++ -O0 编译"
            if [ -x ./yarpgen_gxx_O0 ]; then
                rlRun "file ./yarpgen_gxx_O0 | grep -i elf" 0 "G++ -O0 产物为 ELF"
                local warn_O0
                warn_O0=$(grep -c "warning:" /tmp/yarpgen_gxx_O0_err.txt 2>/dev/null || echo 0)
                rlLogInfo "G++ -O0 警告数: $warn_O0"
            fi
            
            # G++ -O2
            rlRun "g++ -fPIC func.cpp driver.cpp -o yarpgen_gxx_O2 -O2 2>/tmp/yarpgen_gxx_O2_err.txt" 0 "G++ -O2 编译"
            if [ -x ./yarpgen_gxx_O2 ]; then
                rlPass "G++ -O2 编译成功"
                local warn_O2
                warn_O2=$(grep -c "warning:" /tmp/yarpgen_gxx_O2_err.txt 2>/dev/null || echo 0)
                rlLogInfo "G++ -O2 警告数: $warn_O2"
                
                # 显示优化相关的警告差异
                rlRun "grep 'warning:' /tmp/yarpgen_gxx_O2_err.txt | head -10" 0 "G++ -O2 警告 (前 10)"
            fi
            
            # G++ -O3
            rlRun "g++ -fPIC func.cpp driver.cpp -o yarpgen_gxx_O3 -O3 2>/tmp/yarpgen_gxx_O3_err.txt" 0 "G++ -O3 编译"
            if [ -x ./yarpgen_gxx_O3 ]; then
                rlPass "G++ -O3 编译成功"
                local warn_O3
                warn_O3=$(grep -c "warning:" /tmp/yarpgen_gxx_O3_err.txt 2>/dev/null || echo 0)
                rlLogInfo "G++ -O3 警告数: $warn_O3"
            fi
        fi
    rlPhaseEnd

    rlPhaseStartTest "Clang 编译"
        if [ ! -f "func.cpp" ]; then
            rlFail "源代码文件不存在，跳过"
        else
            # Clang -O0
            rlRun "clang++ -fPIC func.cpp driver.cpp -o yarpgen_clang_O0 -O0 2>/tmp/yarpgen_clang_O0_err.txt" 0 "Clang -O0 编译"
            if [ -x ./yarpgen_clang_O0 ]; then
                rlRun "file ./yarpgen_clang_O0 | grep -i elf" 0 "Clang -O0 产物为 ELF"
            fi
            
            # Clang -O2
            rlRun "clang++ -fPIC func.cpp driver.cpp -o yarpgen_clang_O2 -O2 2>/tmp/yarpgen_clang_O2_err.txt" 0 "Clang -O2 编译"
            if [ -x ./yarpgen_clang_O2 ]; then
                rlPass "Clang -O2 编译成功"
                local warn_O2
                warn_O2=$(grep -c "warning:" /tmp/yarpgen_clang_O2_err.txt 2>/dev/null || echo 0)
                rlLogInfo "Clang -O2 警告数: $warn_O2"
                rlRun "grep 'warning:' /tmp/yarpgen_clang_O2_err.txt | head -10" 0 "Clang -O2 警告 (前 10)"
            fi
            
            # Clang -O3
            rlRun "clang++ -fPIC func.cpp driver.cpp -o yarpgen_clang_O3 -O3 2>/tmp/yarpgen_clang_O3_err.txt" 0 "Clang -O3 编译"
            if [ -x ./yarpgen_clang_O3 ]; then
                rlPass "Clang -O3 编译成功"
                local warn_O3
                warn_O3=$(grep -c "warning:" /tmp/yarpgen_clang_O3_err.txt 2>/dev/null || echo 0)
                rlLogInfo "Clang -O3 警告数: $warn_O3"
            fi
        fi
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 "离开临时目录"
        [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "清理临时目录"
        rm -f /tmp/yarpgen_{gxx,clang}_O?_err.txt
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
