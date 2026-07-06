#!/bin/bash
# Functional test: compiler - csmith - 链接场景
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        csmithSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时目录"

        cat > lib.c << 'CEOF'
int add(int a,int b){return a+b;}
int mul(int a,int b){return a*b;}
int divd(int a,int b){return b? a/b:-1;}
const char* ver(void){return "lib_v1";}
CEOF
        cat > lib.h << 'CEOF'
#ifndef L_H
#define L_H
#ifdef __cplusplus
extern "C" {
#endif
int add(int a,int b);int mul(int a,int b);int divd(int a,int b);const char* ver(void);
#ifdef __cplusplus
}
#endif
#endif
CEOF
        cat > main.c << 'CEOF'
#include <stdio.h>
#include <stdlib.h>
#include "lib.h"
int main(void){int a=add(10,20);int m=mul(6,7);int d=divd(100,4);
printf("add=%d mul=%d div=%d ver=%s\n",a,m,d,ver());
if(a!=30||m!=42||d!=25)abort();
printf("LINK_OK\n");return 0;}
CEOF
    rlPhaseEnd

    rlPhaseStartTest "GCC 静态库"
        rlRun "gcc -c lib.c -o lib.o && ar rcs lib.a lib.o" 0 "静态库创建"
        rlRun "gcc main.c -L. -l:lib.a -o s_gcc && ./s_gcc | grep LINK_OK" 0 "GCC 静态链接"
    rlPhaseEnd

    rlPhaseStartTest "GCC 动态库"
        rlRun "gcc -fPIC -c lib.c -o lib_pic.o && gcc -shared -o lib.so lib_pic.o" 0 "动态库创建"
        rlRun "gcc main.c -L. -l:lib.so -o d_gcc && LD_LIBRARY_PATH=. ./d_gcc | grep LINK_OK" 0 "GCC 动态链接"
        rlRun "ldd d_gcc | grep -q lib.so" 0 "ldd 动态库依赖"
    rlPhaseEnd

    rlPhaseStartTest "Clang 库"
        rlRun "clang -fPIC -c lib.c -o lib_clang_pic.o && clang -shared -o lib_clang.so lib_clang_pic.o" 0 "Clang 动态库"
        rlRun "clang main.c -L. -l:lib_clang.so -o d_clang && LD_LIBRARY_PATH=. ./d_clang | grep LINK_OK" 0 "Clang 动态链接"
    rlPhaseEnd

    rlPhaseStartTest "跨编译器链接"
        rlRun "clang main.c -L. -l:lib.so -o cross1 && LD_LIBRARY_PATH=. ./cross1 | grep LINK_OK" 0 "Clang+GCC库"
        rlRun "gcc main.c -L. -l:lib_clang.so -o cross2 && LD_LIBRARY_PATH=. ./cross2 | grep LINK_OK" 0 "GCC+Clang库"
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
