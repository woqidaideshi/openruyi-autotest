#!/bin/bash
# Functional test: compiler - dejagnu - debuginfo (-g/-g3/-ggdb)
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
    dejagnuSetup
    if ! rpm -q gdb 2>/dev/null; then echo "${TEST_SERVER_1_PASSWORD:-openruyi}" | sudo -S dnf install -y gdb 2>/dev/null; fi
    TmpDir=$(mktemp -d)
    rlRun "cd $TmpDir" 0 "Enter temporary directory"

    cat > dbg.c << 'CEOF'
#include <stdio.h>
static int fact(int n){return n<=1?1:n*fact(n-1);}
static int fib(int n){return n<=1?n:fib(n-1)+fib(n-2);}
int main(void){int a=fact(5);int b=fib(10);
printf("debug_ok a=%d b=%d\n",a,b);if(a!=120||b!=55)return 1;return 0;}
CEOF
    rlPhaseEnd

    rlPhaseStartTest "GCC debug"
    for lvl in g g3 ggdb; do
    rlRun "gcc -${lvl} -o dbg_${lvl} dbg.c && ./dbg_${lvl} | grep debug_ok" 0 "GCC -${lvl}"
    rlRun "readelf -S dbg_${lvl} | grep -q '.debug_info'" 0 "GCC -${lvl}: debug_info exists"
    done
    rlPhaseEnd

    rlPhaseStartTest "Clang debug"
    rlRun "clang -g -o dbg_clang dbg.c && ./dbg_clang | grep debug_ok" 0 "Clang -g"
    rlRun "readelf -S dbg_clang | grep -q '.debug_info'" 0 "Clang -g: debug_info exists"
    rlPhaseEnd

    rlPhaseStartTest "GDB breakpoint"
    if command -v gdb >/dev/null 2>&1; then
    echo -e "break fact\nrun\nprint n\nquit" >/tmp/gdb_cmds.txt
    rlRun "gdb -batch -x /tmp/gdb_cmds.txt ./dbg_g 2>&1 | tee /tmp/gdb_out.txt" 0 "GDB breakpointtest"
    grep -q "Breakpoint 1" /tmp/gdb_out.txt && rlPass "GDB breakpointsuccess"
    fi
    rlPhaseEnd

    rlPhaseStartCleanup "Cleanup"
    rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
    rm -f /tmp/gdb_{cmds,out}.txt
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
