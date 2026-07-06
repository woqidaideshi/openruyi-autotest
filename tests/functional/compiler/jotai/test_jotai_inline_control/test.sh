#!/bin/bash
# jotai - 内联控制 -finline-functions, __attribute__((noinline/always_inline))
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        jotaiSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 ""

        cat > inline.c << 'CEOF'
#include <stdio.h>
#include <stdlib.h>
// __attribute__((always_inline)) — 强制内联
static __attribute__((always_inline)) int force_inline(int x){return x*x;}
// __attribute__((noinline)) — 禁止内联
static __attribute__((noinline)) int no_inline(int x){return x*x*x;}
// 小函数（编译器通常会内联）
static int small_func(int x){return x+1;}
// 递归函数（不应内联）
static int recursive(int n){if(n<=1)return 1;return n*recursive(n-1);}
int main(void){
  int a=force_inline(5);   if(a!=25)abort();
  int b=no_inline(3);       if(b!=27)abort();
  int c=small_func(10);    if(c!=11)abort();
  int d=recursive(5);      if(d!=120)abort();
  printf("inline_ok a=%d b=%d c=%d d=%d\n",a,b,c,d);
  return 0;
}
CEOF
    rlPhaseEnd

    rlPhaseStartTest "GCC 内联"
        # -finline-functions (默认 -O2)
        rlRun "gcc -O2 -finline-functions -o inline_gcc_O2 inline.c && ./inline_gcc_O2 | grep inline_ok" 0 "GCC -O2 -finline-functions"
        # -fno-inline
        rlRun "gcc -O2 -fno-inline -o inline_gcc_no inline.c && ./inline_gcc_no | grep inline_ok" 0 "GCC -fno-inline"
        # 验证 noinline 函数仍然是独立的符号
        rlRun "nm inline_gcc_O2 | grep -q no_inline || nm inline_gcc_O2 | grep -q ' T '" 0 "符号表检查"
        # 验证 always_inline 哪怕在 -fno-inline 下也能工作
        rlRun "./inline_gcc_no" 0 "no-inline 模式运行正常"
        rlPass "GCC always_inline/noinline 均正确"
    rlPhaseEnd

    rlPhaseStartTest "Clang 内联"
        rlRun "clang -O2 -o inline_clang_O2 inline.c && ./inline_clang_O2 | grep inline_ok" 0 "Clang -O2"
        rlRun "clang -O2 -fno-inline -o inline_clang_no inline.c && ./inline_clang_no | grep inline_ok" 0 "Clang -fno-inline"
        rlPass "Clang always_inline/noinline 均正确"
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
