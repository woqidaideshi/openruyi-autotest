#!/bin/bash
# jotai - inline -finline-functions, __attribute__((noinline/always_inline))
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 jotaiSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 ""

 cat > inline.c << 'CEOF'
#include <stdio.h>
#include <stdlib.h>
// __attribute__((always_inline)) — inline
static __attribute__((always_inline)) int force_inline(int x){return x*x;}
// __attribute__((noinline)) — disableinline
static __attribute__((noinline)) int no_inline(int x){return x*x*x;}
// function（compilewillinline）
static int small_func(int x){return x+1;}
// recursivefunction（noshouldinline）
static int recursive(int n){if(n<=1)return 1;return n*recursive(n-1);}
int main(void){
 int a=force_inline(5); if(a!=25)abort();
 int b=no_inline(3); if(b!=27)abort();
 int c=small_func(10); if(c!=11)abort();
 int d=recursive(5); if(d!=120)abort();
 printf("inline_ok a=%d b=%d c=%d d=%d\n",a,b,c,d);
 return 0;
}
CEOF
 rlPhaseEnd

 rlPhaseStartTest "GCC inline"
 # -finline-functions (default -O2)
 rlRun "gcc -O2 -finline-functions -o inline_gcc_O2 inline.c &&./inline_gcc_O2 | grep inline_ok" 0 "GCC -O2 -finline-functions"
 # -fno-inline
 rlRun "gcc -O2 -fno-inline -o inline_gcc_no inline.c &&./inline_gcc_no | grep inline_ok" 0 "GCC -fno-inline"
 # verify noinline functionisalonesymbol
 rlRun "nm inline_gcc_O2 | grep -q no_inline || nm inline_gcc_O2 | grep -q ' T '" 0 "symboltablecheck"
 # verify always_inline in -fno-inline 
 rlRun "./inline_gcc_no" 0 "no-inline moderunnormal"
 rlPass "GCC always_inline/noinline correct"
 rlPhaseEnd

 rlPhaseStartTest "Clang inline"
 rlRun "clang -O2 -o inline_clang_O2 inline.c &&./inline_clang_O2 | grep inline_ok" 0 "Clang -O2"
 rlRun "clang -O2 -fno-inline -o inline_clang_no inline.c &&./inline_clang_no | grep inline_ok" 0 "Clang -fno-inline"
 rlPass "Clang always_inline/noinline correct"
 rlPhaseEnd

 rlPhaseStartCleanup "Cleanup"
 rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
 rlPhaseEnd
 rlJournalPrintText
rlJournalEnd
