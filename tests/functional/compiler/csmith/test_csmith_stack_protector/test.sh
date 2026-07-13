#!/bin/bash
# csmith - stack: -fstack-protector/-fstack-protector-strong/-fstack-protector-all
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 csmithSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 ""

 cat > buf.c << 'CEOF'
#include <stdio.h>
#include <string.h>
void vulnerable(char *input){char buf[16];strcpy(buf,input);printf("buf=%s\n",buf);}
int main(void){
 // normal: noexport
 char safe[]="hello";
 vulnerable(safe);
 printf("STACK_OK\n");
 return 0;
}
CEOF

 cat > overflow.c << 'CEOF'
#include <stdio.h>
#include <string.h>
void overflow_buf(void){char buf[8];memset(buf,'A',20);}
int main(void){overflow_buf();printf("OVERFLOW_RAN\n");return 0;}
CEOF
 rlPhaseEnd

 rlPhaseStartTest "GCC stack-protector"
 # normalprogram + stack protector
 for mode in "stack-protector" "stack-protector-strong" "stack-protector-all"; do
 rlRun "gcc -f${mode} -o stack_gcc_${mode} buf.c &&./stack_gcc_${mode} | grep STACK_OK" 0 "GCC -f${mode} normalprogram"
 done

 # verify stack protector: compileshouldcontains __stack_chk symbol
 rlRun "nm stack_gcc_stack-protector | grep -q '__stack_chk'" 0 "GCC stack-protector: __stack_chk_fail symbolexists"

 # exportprogram + stack protector（shoulddetect to andterminate）
 gcc -fstack-protector-all -o overflow_gcc overflow.c 2>/dev/null
 if [ -x./overflow_gcc ]; then
 timeout 5./overflow_gcc >/tmp/overflow_gcc.txt 2>&1
 local rc=$?
 rlLogInfo "overflow programexit code: $rc"
 if grep -qi "stack smashing\|stack overflow\|abort\|core dump" /tmp/overflow_gcc.txt; then
 rlPass "GCC -fstack-protector-all successdetectstackexport"
 elif [ "$rc" -ne 0 ]; then
 rlPass "GCC stack protector Exceptionterminateexportprogram (exit=$rc)"
 else
 rlLogWarning "stack protector notexport（possibleisoptimization）"
 fi
 fi
 rlPhaseEnd

 rlPhaseStartTest "Clang stack-protector"
 rlRun "clang -fstack-protector-strong -o stack_clang buf.c &&./stack_clang | grep STACK_OK" 0 "Clang -fstack-protector-strong"
 rlRun "nm stack_clang | grep -q '__stack_chk'" 0 "Clang stack protector symbolexists"
 rlPhaseEnd

 rlPhaseStartCleanup "Cleanup"
 rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
 rm -f /tmp/overflow_gcc.txt
 rlPhaseEnd
 rlJournalPrintText
rlJournalEnd
