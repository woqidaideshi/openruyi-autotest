#!/bin/bash
# Functional test: compiler - dejagnu - GCC compiletestwith
# Create minimal GCC test program, with DejaGnu runtest framework executes and validates results

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 dejagnuSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary directory"
 
 # create GCC testsuite directory structure
 mkdir -p gcc-testsuite/gcc.dg
 
 # Create test C source file
 cat > gcc-testsuite/gcc.dg/dejagnu_test.c << 'CEOF'
/* { dg-do run } */
/* { dg-options "-O2" } */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void) {
 /* basictest */
 int a = 42, b = 58, c = a + b;
 if (c != 100) abort();
 
 /* test */
 char buf[32];
 snprintf(buf, sizeof(buf), "gcc test %d", c);
 if (strcmp(buf, "gcc test 100") != 0) abort();
 
 /* memoryoperationtest */
 int arr[10] = {0,1,2,3,4,5,6,7,8,9};
 int sum = 0;
 for (int i = 0; i < 10; i++) sum += arr[i];
 if (sum != 45) abort();
 
 printf("GCC_DG_TEST_PASSED\n");
 return 0;
}
CEOF
 
 # create DejaGnu.exp file
 cat > gcc-testsuite/gcc.dg/dejagnu_test.exp << 'EEOF'
# GCC DejaGnu test driver
load_lib gcc-dg.exp

dg-init
dg-runtest "$srcdir/$subdir/dejagnu_test.c" "-O2" ""
dg-finish
EEOF
 
 rlLogInfo "testfilealreadycreate"
 rlPhaseEnd

 rlPhaseStartTest "GCC DejaGnu test"
 # enter testsuite directoryExecute runtest
 cd gcc-testsuite
 
 # set GCC path
 export GCC_UNDER_TEST=gcc
 export GXX_UNDER_TEST=g++
 
 runtest --tool gcc gcc.dg/dejagnu_test.exp 2>&1 | tee /tmp/dejagnu_gcc_run.log
 local rc=${PIPESTATUS[0]}
 
 rlRun "ls -la gcc.log gcc.sum 2>/dev/null || true" 0 "check.log/.sum file"
 
 # verify.sum filecontent
 if [ -f gcc.sum ]; then
 rlRun "cat gcc.sum" 0 "display.sum content"
 
 # check whether there is PASS 
 if grep -q "^PASS:" gcc.sum; then
 local pass_count
 pass_count=$(grep -c "^PASS:" gcc.sum)
 rlPass "GCC DejaGnu testpassed ($pass_count PASS)"
 else
 rlFail "GCC.sum filenotcontains PASS result"
 fi
 
 # checknoshouldhas FAIL
 if grep -q "^FAIL:" gcc.sum; then
 local fail_count
 fail_count=$(grep -c "^FAIL:" gcc.sum)
 rlFail "GCC testexists $fail_count failed"
 else
 rlPass "GCC testno FAIL"
 fi
 else
 rlFail "notGenerate gcc.sum file"
 fi
 
 # verify.log filecontainscompile/runoutput
 if [ -f gcc.log ]; then
 if grep -q "GCC_DG_TEST_PASSED\|PASS\|dg-runtest" gcc.log; then
 rlPass "gcc.log containspretestoutput"
 fi
 fi
 
 cd "$TmpDir"
 rlPhaseEnd

 rlPhaseStartCleanup "Cleanup"
 rlRun "cd /" 0 "Leave temporary directory"
 [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "Clean up temporary directory"
 rm -f /tmp/dejagnu_gcc_run.log
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
