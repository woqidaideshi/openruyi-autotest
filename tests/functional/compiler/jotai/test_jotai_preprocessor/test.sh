#!/bin/bash

# Functional test: compiler - jotai - preprocessing

. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

 rlPhaseStartSetup "Environment setup"

 jotaiSetup

 TmpDir=$(mktemp -d)

 rlRun "cd $TmpDir" 0 "Enter temporary directory"



 cat > pp.c << 'CEOF'

#include <stdio.h>

#include "inc.h"

#ifndef VER

#define VER "unknown"

#endif

int main(void){printf("VER=%s\n",VER);

#ifdef HAVE_FEAT

printf("FEAT=1\n");

#else

printf("FEAT=0\n");

#endif

printf("PP_OK\n");return 0;}

CEOF

 mkdir -p inc; echo '#define HDR 1' > inc/inc.h



 cat > mac.c << 'CEOF'

#include <stdio.h>

#define S(x) #x

#define C(a,b) a##b

#define SQ(x) ((x)*(x))

int main(void){printf("S=%s\n",S(hello));

int xy=100;printf("C=%d\n",C(x,y));

printf("SQ=%d\n",SQ(5));

printf("MACRO_OK\n");return 0;}

CEOF

 rlPhaseEnd



 rlPhaseStartTest "GCC preprocessing"

 rlRun "gcc -E pp.c 2>/dev/null | grep -q main" 0 "GCC -E preprocessing"

 rlRun "gcc -DVER=\\\"2.0\\\" -DHAVE_FEAT -Iinc -o pp_gcc pp.c &&./pp_gcc|tee /tmp/pp_gcc.txt" 0 "GCC -D/-I"

 grep -q "VER=2.0" /tmp/pp_gcc.txt && rlPass "VER macrocorrect"

 grep -q "FEAT=1" /tmp/pp_gcc.txt && rlPass "HAVE_FEAT compile"

 rlRun "gcc -o mac_gcc mac.c &&./mac_gcc|tee /tmp/mac_gcc.txt" 0 "GCC macrotest"

 grep -q "S=hello" /tmp/mac_gcc.txt && rlPass "# "

 grep -q "C=100" /tmp/mac_gcc.txt && rlPass "## connection"

 grep -q "SQ=25" /tmp/mac_gcc.txt && rlPass "macroat begin"

 rlPhaseEnd



 rlPhaseStartTest "Clang preprocessing"

 rlRun "clang -E pp.c 2>/dev/null | grep -q main" 0 "Clang -E"

 rlRun "clang -DVER=\\\"2.0\\\" -DHAVE_FEAT -Iinc -o pp_clang pp.c &&./pp_clang | grep PP_OK" 0 "Clang -D/-I"

 rlRun "clang -o mac_clang mac.c &&./mac_clang | grep MACRO_OK" 0 "Clang macro"

 rlPhaseEnd



 rlPhaseStartCleanup "Cleanup"

 rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""

 rm -f /tmp/{pp,mac}_gcc.txt

 rlPhaseEnd

 rlJournalPrintText

rlJournalEnd

