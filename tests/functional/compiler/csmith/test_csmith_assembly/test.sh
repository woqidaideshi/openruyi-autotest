#!/bin/bash
# Functional test: compiler - csmith - assembly output
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 csmithSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary directory"

 cat > asm.c << 'CEOF'
#include <stdio.h>
static int comp(int a,int b,int c){int x=a+b;int y=x*c;int z=y-a;return z;}
int main(void){int r=comp(5,10,3);printf("r=%d\n",r);
if(r!=40)return 1;printf("ASM_OK\n");return 0;}
CEOF
 rlPhaseEnd

 rlPhaseStartTest "GCC Assembly"
 rlRun "gcc -S -O2 asm.c -o asm_gcc_O2.s" 0 "GCC -S -O2"
 [ -f asm_gcc_O2.s ] && [ "$(wc -l < asm_gcc_O2.s)" -gt 5 ] && rlPass "GCC Assemblyhas"
 rlRun "gcc -S -O0 asm.c -o asm_gcc_O0.s" 0 "GCC -S -O0"
 diff -q asm_gcc_O0.s asm_gcc_O2.s >/dev/null 2>&1 || rlPass "GCC -O0 vs -O2 Assemblyhasdiff"
 rlPhaseEnd

 rlPhaseStartTest "Clang Assembly"
 rlRun "clang -S -O2 asm.c -o asm_clang_O2.s" 0 "Clang -S -O2"
 [ -f asm_clang_O2.s ] && [ "$(wc -l < asm_clang_O2.s)" -gt 3 ] && rlPass "Clang Assemblyhas"
 rlRun "gcc -c asm_clang_O2.s -o asm_from.o && gcc asm_from.o -o asm_bin &&./asm_bin | grep ASM_OK" 0 "Assembly+run"
 rlPhaseEnd

 rlPhaseStartCleanup "Cleanup"
 rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
 rlPhaseEnd
 rlJournalPrintText
rlJournalEnd
