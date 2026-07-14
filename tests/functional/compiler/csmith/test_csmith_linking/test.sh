#!/bin/bash
# Functional test: compiler - csmith - linking scenarios
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
    csmithSetup
    TmpDir=$(mktemp -d)
    rlRun "cd $TmpDir" 0 "Enter temporary directory"

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

    rlPhaseStartTest "GCC static library"
    rlRun "gcc -c lib.c -o lib.o && ar rcs lib.a lib.o" 0 "static librarycreate"
    rlRun "gcc main.c -L. -l:lib.a -o s_gcc &&./s_gcc | grep LINK_OK" 0 "GCC link"
    rlPhaseEnd

    rlPhaseStartTest "GCC shared library"
    rlRun "gcc -fPIC -c lib.c -o lib_pic.o && gcc -shared -o lib.so lib_pic.o" 0 "shared librarycreate"
    rlRun "gcc main.c -L. -l:lib.so -o d_gcc && LD_LIBRARY_PATH=../d_gcc | grep LINK_OK" 0 "GCC link"
    rlRun "ldd d_gcc | grep -q lib.so" 0 "ldd shared libraryDependencies"
    rlPhaseEnd

    rlPhaseStartTest "Clang library"
    rlRun "clang -fPIC -c lib.c -o lib_clang_pic.o && clang -shared -o lib_clang.so lib_clang_pic.o" 0 "Clang shared library"
    rlRun "clang main.c -L. -l:lib_clang.so -o d_clang && LD_LIBRARY_PATH=../d_clang | grep LINK_OK" 0 "Clang link"
    rlPhaseEnd

    rlPhaseStartTest "cross-compiler linking"
    rlRun "clang main.c -L. -l:lib.so -o cross1 && LD_LIBRARY_PATH=../cross1 | grep LINK_OK" 0 "Clang+GCClibrary"
    rlRun "gcc main.c -L. -l:lib_clang.so -o cross2 && LD_LIBRARY_PATH=../cross2 | grep LINK_OK" 0 "GCC+Clanglibrary"
    rlPhaseEnd

    rlPhaseStartCleanup "Cleanup"
    rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
