#!/bin/bash

# csmith - LTO (Link-Time Optimization) -flto

. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

 rlPhaseStartSetup "Environment setup"

 csmithSetup

 TmpDir=$(mktemp -d)

 rlRun "cd $TmpDir" 0 ""



 cat > mod1.c << 'CEOF'

int compute(int x){int s=0;for(int i=0;i<x;i++)s+=i*i;return s;}

int get_const(void){return 42;}

CEOF

 cat > mod2.c << 'CEOF'

int transform(int x){return x*2+1;}

CEOF

 cat > mod.h << 'CEOF'

int compute(int x);int get_const(void);int transform(int x);

CEOF

 cat > lto_main.c << 'CEOF'

#include <stdio.h>

#include <stdlib.h>

#include "mod.h"

int main(void){int c=compute(5);int g=get_const();int t=transform(10);

printf("compute(5)=%d const=%d transform(10)=%d\n",c,g,t);

if(c!=30||g!=42||t!=21)abort();

printf("LTO_OK\n");return 0;}

CEOF

 rlPhaseEnd



 rlPhaseStartTest "GCC LTO"

 # -flto compile+link

 rlRun "gcc -flto -O2 -c mod1.c -o mod1_lto.o" 0 "GCC -flto compile mod1"

 rlRun "gcc -flto -O2 -c mod2.c -o mod2_lto.o" 0 "GCC -flto compile mod2"

 rlRun "gcc -flto -O2 -o lto_gcc lto_main.c mod1_lto.o mod2_lto.o &&./lto_gcc | grep LTO_OK" 0 "GCC -flto link+run"



 # comparisonnon- LTO compile (Ensureconsistent)

 rlRun "gcc -O2 -o no_lto_gcc lto_main.c mod1.c mod2.c &&./no_lto_gcc | grep LTO_OK" 0 "GCC no LTO"

./lto_gcc >/tmp/lto_gcc.txt 2>&1;./no_lto_gcc >/tmp/nolto_gcc.txt 2>&1

 diff /tmp/lto_gcc.txt /tmp/nolto_gcc.txt >/dev/null 2>&1 && rlPass "GCC LTO/non-LTO output consistent" || rlLogInfo "output differs"

 rlPhaseEnd



 rlPhaseStartTest "Clang LTO"

 rlRun "clang -flto -O2 -c mod1.c -o mod1_lto_c.o && clang -flto -O2 -c mod2.c -o mod2_lto_c.o" 0 "Clang -flto compile"

 rlRun "clang -flto -O2 -o lto_clang lto_main.c mod1_lto_c.o mod2_lto_c.o &&./lto_clang | grep LTO_OK" 0 "Clang -flto link+run"

 rlPhaseEnd



 rlPhaseStartCleanup "Cleanup"

 rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""

 rm -f /tmp/{lto,nolto}_gcc.txt

 rlPhaseEnd

 rlJournalPrintText

rlJournalEnd

