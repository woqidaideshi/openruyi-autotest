#!/bin/bash
# Functional test: compiler - yarpgen - differential testing（G++ vs Clang output comparison）
# core: G++ and Clang compile YARPGen randomprogrampostruncompareoutput
# output mismatchcompileexistsoptimization Bug

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

YARPGEN_BIN="/tmp/yarpgen/build/yarpgen"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 yarpgenSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary directory"
 
 if [ ! -x "$YARPGEN_BIN" ]; then
 rlFail "yarpgen noavailable，skiptest"
 fi
 rlPhaseEnd

 rlPhaseStartTest "differential testing"
 local diff_failures=0
 local total_tests=0
 
 # run 3 differential testing
 for round in 1 2 3; do
 rlLogInfo "======== YARPGen differential testing # ${round} ========"
 
 # createalonedirectory
 mkdir -p "round_${round}"
 cd "round_${round}"
 
 # Generate random program
 $YARPGEN_BIN > /tmp/yarpgen_gen_${round}.log 2>&1
 if [ ! -f "driver.cpp" ] || [ ! -f "func.cpp" ]; then
 rlFail "# ${round}: YARPGen programGeneratefailed"
 cd "$TmpDir"
 continue
 fi
 
 total_tests=$((total_tests + 1))
 rlLogInfo "# ${round}: Generatesuccess (func.cpp: $(wc -l < func.cpp) lines, driver.cpp: $(wc -l < driver.cpp) lines)"
 
 # G++ compile
 g++ -fPIC func.cpp driver.cpp -o test_gxx -O2 2>/tmp/yarpgen_diff_gxx_err_${round}.txt
 local gxx_rc=$?
 
 # Clang compile
 clang++ -fPIC func.cpp driver.cpp -o test_clang -O2 2>/tmp/yarpgen_diff_clang_err_${round}.txt
 local clang_rc=$?
 
 if [ "$gxx_rc" -ne 0 ]; then
 rlFail "# ${round}: G++ Compile failed"
 cd "$TmpDir"
 continue
 fi
 
 if [ "$clang_rc" -ne 0 ]; then
 rlFail "# ${round}: Clang Compile failed"
 cd "$TmpDir"
 continue
 fi
 
 rlPass "# ${round}: G++ and Clang Compile succeeded"
 
 # runandoutput
 timeout 10./test_gxx > gxx_output.txt 2>/tmp/yarpgen_run_gxx_${round}.txt
 local gxx_run_rc=$?
 
 timeout 10./test_clang > clang_output.txt 2>/tmp/yarpgen_run_clang_${round}.txt
 local clang_run_rc=$?
 
 # checkrun
 if grep -qi "segmentation fault\|core dumped\|stack\|abort" /tmp/yarpgen_run_gxx_${round}.txt 2>/dev/null; then
 rlLogWarning "# ${round}: G++ runtime possible"
 fi
 if grep -qi "segmentation fault\|core dumped\|stack\|abort" /tmp/yarpgen_run_clang_${round}.txt 2>/dev/null; then
 rlLogWarning "# ${round}: Clang runtime possible"
 fi
 
 # core: output comparison
 if [ -f "gxx_output.txt" ] && [ -f "clang_output.txt" ]; then
 if diff -q gxx_output.txt clang_output.txt >/dev/null 2>&1; then
 rlPass "# ${round}: G++ and Clang output consistent ✓"
 else
 diff_failures=$((diff_failures + 1))
 
 # Show diff
 echo "=== output diff ==="
 diff gxx_output.txt clang_output.txt | head -30
 echo "=== G++ output ==="
 cat gxx_output.txt
 echo "=== Clang output ===" 
 cat clang_output.txt
 
 rlFail "# ${round}: differential testingfailed — G++/Clang output mismatch（possibleexistscompileoptimization Bug）"
 fi
 else
 rlFail "# ${round}: outputfile"
 fi
 
 cd "$TmpDir"
 done
 
 # Summary
 rlLogInfo "YARPGen differential testingComplete: $total_tests, $diff_failures noconsistent"
 if [ "$diff_failures" -eq 0 ] && [ "$total_tests" -gt 0 ]; then
 rlPass "all YARPGen differential testingpassed: nocompileoutput mismatch"
 fi
 rlPhaseEnd

 rlPhaseStartCleanup "Cleanup"
 rlRun "cd /" 0 "Leave temporary directory"
 [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "Clean up temporary directory"
 rm -f /tmp/yarpgen_{gen,diff_{gxx,clang}_err,run_{gxx,clang}}_*.txt
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
