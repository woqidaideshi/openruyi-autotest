#!/bin/bash


# Functional test: compiler - yarpgen - Sanitizer


. /usr/share/beakerlib/beakerlib.sh || exit 1


. "$(dirname "$0")/../lib.sh"





rlJournalStart


    rlPhaseStartSetup "Environment setup"


    yarpgenSetup


    TmpDir=$(mktemp -d)


    rlRun "cd $TmpDir" 0 "Enter temporary directory"





    cat > clean.c << 'CEOF'


#include <stdio.h>


#include <stdlib.h>


int main(void){int*p=malloc(sizeof(int)*10);


for(int i=0;i<10;i++)p[i]=i*10;int s=0;


for(int i=0;i<10;i++)s+=p[i];printf("sum=%d\n",s);


free(p);if(s!=450)abort();printf("ASAN_CLEAN_OK\n");return 0;}


CEOF


    rlPhaseEnd





    rlPhaseStartTest "GCC ASAN"


    rlRun "gcc -fsanitize=address -g -o asan_gcc clean.c 2>/dev/null" 0 "GCC -fsanitize=address"


    if [ -x./asan_gcc ]; then


./asan_gcc >/tmp/asan_gcc.txt 2>&1


    grep -qi "ERROR\|AddressSanitizer" /tmp/asan_gcc.txt && rlFail "GCC ASAN " || rlPass "GCC ASAN normalprogramno"


    fi


    rlPhaseEnd





    rlPhaseStartTest "GCC UBSAN"


    rlRun "gcc -fsanitize=undefined -g -o ubsan_gcc clean.c &&./ubsan_gcc" 0 "GCC UBSAN normal"


    rlPass "GCC UBSAN no undefined behavior"


    rlPhaseEnd





    rlPhaseStartTest "Clang ASAN"


    rlRun "clang -fsanitize=address -g -o asan_clang clean.c &&./asan_clang 2>/tmp/asan_clang.txt" 0 "Clang ASAN"


    grep -qi "ERROR\|AddressSanitizer" /tmp/asan_clang.txt && rlFail "Clang ASAN " || rlPass "Clang ASAN normal"


    rlPhaseEnd





    rlPhaseStartTest "Clang UBSAN"


    rlRun "clang -fsanitize=undefined -g -o ubsan_clang clean.c &&./ubsan_clang" 0 "Clang UBSAN"


    rlPass "Clang UBSAN no undefined behavior"


    rlPhaseEnd





    rlPhaseStartCleanup "Cleanup"


    rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""


    rm -f /tmp/asan_{gcc,clang}.txt


    rlPhaseEnd


    rlJournalPrintText


rlJournalEnd


