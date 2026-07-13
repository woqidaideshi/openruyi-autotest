#!/bin/bash
# Functional test: compiler - dejagnu - G++ compiletestwith
# Create minimal C++ test program，with DejaGnu runtest framework executes and validates results

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 dejagnuSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary directory"
 
 # create G++ testsuite directory structure
 mkdir -p gxx-testsuite/g++.dg
 
 # Create test C++ source file
 cat > gxx-testsuite/g++.dg/dejagnu_gxx_test.C << 'CEOF'
// { dg-do run }
// { dg-options "-O2 -std=c++17" }
#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
#include <numeric>
#include <cmath>

int main() {
 // test
 std::vector<int> vec = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
 
 // STL test
 int sum = std::accumulate(vec.begin(), vec.end(), 0);
 if (sum != 55) abort();
 
 // Lambda test
 auto square = [](int x) { return x * x; };
 std::vector<int> squares;
 std::transform(vec.begin(), vec.end(), std::back_inserter(squares), square);
 if (squares[0] != 1 || squares[9] != 100) abort();
 
 // test
 std::string s = "g++";
 s += " dejagnu";
 s += " test passed";
 if (s.find("passed") == std::string::npos) abort();
 
 // floating-pointtest
 double d = std::sqrt(144.0);
 if (std::abs(d - 12.0) > 0.0001) abort();
 
 std::cout << "GXX_DG_TEST_PASSED" << std::endl;
 return 0;
}
CEOF
 
 # create DejaGnu.exp file
 cat > gxx-testsuite/g++.dg/dejagnu_gxx_test.exp << 'EEOF'
# G++ DejaGnu test driver
load_lib g++-dg.exp

dg-init
dg-runtest "$srcdir/$subdir/dejagnu_gxx_test.C" "-O2 -std=c++17" ""
dg-finish
EEOF
 
 rlLogInfo "G++ testfilealreadycreate"
 rlPhaseEnd

 rlPhaseStartTest "G++ DejaGnu test"
 cd gxx-testsuite
 
 export GCC_UNDER_TEST=gcc
 export GXX_UNDER_TEST=g++
 
 runtest --tool g++ g++.dg/dejagnu_gxx_test.exp 2>&1 | tee /tmp/dejagnu_gxx_run.log
 local rc=${PIPESTATUS[0]}
 
 # verify.sum file
 if [ -f g++.sum ]; then
 rlRun "cat g++.sum" 0 "display g++.sum content"
 
 if grep -q "^PASS:" g++.sum; then
 local pass_count
 pass_count=$(grep -c "^PASS:" g++.sum)
 rlPass "G++ DejaGnu testpassed ($pass_count PASS)"
 else
 rlFail "G++.sum filenotcontains PASS result"
 fi
 
 if grep -q "^FAIL:" g++.sum; then
 local fail_count
 fail_count=$(grep -c "^FAIL:" g++.sum)
 rlFail "G++ testexists $fail_count failed"
 else
 rlPass "G++ testno FAIL"
 fi
 else
 rlFail "notGenerate g++.sum file"
 fi
 
 # verify.log file
 if [ -f g++.log ]; then
 if grep -q "GXX_DG_TEST_PASSED\|PASS\|dg-runtest" g++.log; then
 rlPass "g++.log containspreoutput"
 fi
 fi
 
 cd "$TmpDir"
 rlPhaseEnd

 rlPhaseStartCleanup "Cleanup"
 rlRun "cd /" 0 "Leave temporary directory"
 [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "Clean up temporary directory"
 rm -f /tmp/dejagnu_gxx_run.log
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
