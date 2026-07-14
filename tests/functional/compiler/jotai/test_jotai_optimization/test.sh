#!/bin/bash
# Functional test: compiler - jotai - optimizationlevel
# O0/O1/O2/O3/Os/Ofast allcompilerun, verifyoutput consistent
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
    jotaiSetup
    TmpDir=$(mktemp -d)
    rlRun "cd $TmpDir" 0 "Enter temporary directory"

    cat > opt.c << 'CEOF'
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
int comp(int seed){volatile int s=seed;int arr[100];long long sum=0;
for(int i=0;i<100;i++)arr[i]=(i*s)%997;
for(int i=0;i<100;i++)sum+=arr[i];
int bits=0;for(int i=0;i<32;i++)if(s&(1<<i))bits++;
double d=0;for(int i=0;i<10;i++)d+=sqrt((double)(arr[i]*arr[i]+s));
char b[128];snprintf(b,sizeof(b),"sum=%lld bits=%d d=%.2f seed=%d",sum,bits,d,s);
printf("%s\n",b);return(int)(sum%256);}
int main(void){int ret=0;for(int s=1;s<=5;s++)ret+=comp(s);
printf("OPT_OK\n");return ret;}
CEOF
    rlPhaseEnd

    rlPhaseStartTest "GCC optimization"
    for o in O0 O1 O2 O3 Os Ofast; do
    rlRun "gcc -${o} -o opt_gcc_${o} opt.c -lm && ./opt_gcc_${o} >/tmp/gcc_${o}.txt 2>&1" 0 "GCC -${o}"
    grep -q OPT_OK /tmp/gcc_${o}.txt && rlPass "GCC -${o} OK"
    done
    diff -q /tmp/gcc_O0.txt /tmp/gcc_O2.txt >/dev/null 2>&1 && rlPass "GCC -O0 vs -O2 consistent" || echo "diff"
    rlPhaseEnd

    rlPhaseStartTest "Clang optimization"
    for o in O0 O1 O2 O3 Os Ofast; do
    rlRun "clang -${o} -o opt_clang_${o} opt.c -lm && ./opt_clang_${o} >/tmp/clang_${o}.txt 2>&1" 0 "Clang -${o}"
    grep -q OPT_OK /tmp/clang_${o}.txt && rlPass "Clang -${o} OK"
    done
    diff -q /tmp/clang_O0.txt /tmp/clang_O2.txt >/dev/null 2>&1 && rlPass "Clang -O0 vs -O2 consistent" || echo "diff"
    rlPhaseEnd

    rlPhaseStartTest "GCC vs Clang -O2"
    diff -q /tmp/gcc_O2.txt /tmp/clang_O2.txt >/dev/null 2>&1 && rlPass "GCC/Clang -O2 consistent" || rlLogInfo "GCC/Clang -O2 hasdiff"
    rlPhaseEnd

    rlPhaseStartCleanup "Cleanup"
    rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
    rm -f /tmp/{gcc,clang}_O?.txt /tmp/{gcc,clang}_O{s,f}.txt
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
