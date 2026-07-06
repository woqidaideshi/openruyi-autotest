#!/bin/bash
# Functional test: compiler - csmith - 汇编输出
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        csmithSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时目录"

        cat > asm.c << 'CEOF'
#include <stdio.h>
static int comp(int a,int b,int c){int x=a+b;int y=x*c;int z=y-a;return z;}
int main(void){int r=comp(5,10,3);printf("r=%d\n",r);
if(r!=40)return 1;printf("ASM_OK\n");return 0;}
CEOF
    rlPhaseEnd

    rlPhaseStartTest "GCC 汇编"
        rlRun "gcc -S -O2 asm.c -o asm_gcc_O2.s" 0 "GCC -S -O2"
        [ -f asm_gcc_O2.s ] && [ "$(wc -l < asm_gcc_O2.s)" -gt 5 ] && rlPass "GCC 汇编有效"
        rlRun "gcc -S -O0 asm.c -o asm_gcc_O0.s" 0 "GCC -S -O0"
        diff -q asm_gcc_O0.s asm_gcc_O2.s >/dev/null 2>&1 || rlPass "GCC -O0 vs -O2 汇编有差异"
    rlPhaseEnd

    rlPhaseStartTest "Clang 汇编"
        rlRun "clang -S -O2 asm.c -o asm_clang_O2.s" 0 "Clang -S -O2"
        [ -f asm_clang_O2.s ] && [ "$(wc -l < asm_clang_O2.s)" -gt 3 ] && rlPass "Clang 汇编有效"
        rlRun "gcc -c asm_clang_O2.s -o asm_from.o && gcc asm_from.o -o asm_bin && ./asm_bin | grep ASM_OK" 0 "汇编回编+运行"
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
